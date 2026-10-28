// スクリーンショットに載せるキャッチコピーを、CoreText (AppKit) で PNG に描画する。
//
// 既存の text_to_image.sh は ImageMagick の label: で描いているが、この Mac の ImageMagick には raqm / pango が無く、
// アラビア語・ヘブライ語の字形結合と右→左の並びを扱えない (`magick -list configure` の DELEGATES で確認)。
// AppKit の NSAttributedString は OS のテキストエンジンで描くため、日本語・アラビア語・ヘブライ語・タイ語を
// フォント指定なしで正しく描ける。
//
// 使い方:
//   swift scripts/translation/render_text.swift <jobs.json>
//
// jobs.json は次の要素の配列。出力 PNG は幅 width px・高さは折り返し後の文字の高さで、背景は透明。
//   {"text": "...", "output": "out.png", "width": 1200, "fontSize": 96, "weight": "bold" | "regular", "color": "#800080"}
//
// 冪等: 同じ入力なら同じ PNG を上書きする。

import AppKit
import Foundation

/// 1 枚の文字画像の描画指示。
struct RenderJob: Decodable {
  /// 描く文字列。改行を含んでよい
  let text: String
  /// 出力する PNG のパス
  let output: String
  /// 画像の幅 (px)。文字はこの幅で中央揃えに折り返す
  let width: Double
  /// フォントサイズ (px)
  let fontSize: Double
  /// "bold" か "regular"
  let weight: String
  /// 文字色 (#RRGGBB)
  let color: String
}

/// "#RRGGBB" を NSColor にする。形式が違えば終了する。
func parseColor(hex: String) -> NSColor {
  var value: UInt64 = 0
  guard hex.hasPrefix("#"), hex.count == 7, Scanner(string: String(hex.dropFirst())).scanHexInt64(&value) else {
    FileHandle.standardError.write("ERROR: color must be #RRGGBB: \(hex)\n".data(using: .utf8)!)
    exit(2)
  }
  return NSColor(
    srgbRed: CGFloat((value >> 16) & 0xff) / 255,
    green: CGFloat((value >> 8) & 0xff) / 255,
    blue: CGFloat(value & 0xff) / 255,
    alpha: 1
  )
}

/// 1 件の指示を PNG に描いて書き出す。
func render(job: RenderJob) throws {
  let paragraph = NSMutableParagraphStyle()
  paragraph.alignment = .center
  paragraph.lineBreakMode = .byWordWrapping
  let attributed = NSAttributedString(
    string: job.text,
    attributes: [
      .font: NSFont.systemFont(ofSize: job.fontSize, weight: job.weight == "bold" ? .bold : .regular),
      .foregroundColor: parseColor(hex: job.color),
      .paragraphStyle: paragraph,
    ]
  )
  let options: NSString.DrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
  let height = ceil(attributed.boundingRect(with: NSSize(width: job.width, height: .greatestFiniteMagnitude), options: options).height)
  guard
    let bitmap = NSBitmapImageRep(
      bitmapDataPlanes: nil, pixelsWide: Int(job.width), pixelsHigh: Int(height), bitsPerSample: 8, samplesPerPixel: 4,
      hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
    ), let context = NSGraphicsContext(bitmapImageRep: bitmap)
  else {
    throw NSError(domain: "render_text", code: 1, userInfo: [NSLocalizedDescriptionKey: "bitmap を作れない: \(job.output)"])
  }
  NSGraphicsContext.saveGraphicsState()
  NSGraphicsContext.current = context
  attributed.draw(with: NSRect(x: 0, y: 0, width: job.width, height: height), options: options)
  NSGraphicsContext.restoreGraphicsState()
  guard let png = bitmap.representation(using: .png, properties: [:]) else {
    throw NSError(domain: "render_text", code: 1, userInfo: [NSLocalizedDescriptionKey: "PNG にできない: \(job.output)"])
  }
  try png.write(to: URL(fileURLWithPath: job.output))
}

guard CommandLine.arguments.count == 2 else {
  FileHandle.standardError.write("usage: swift render_text.swift <jobs.json>\n".data(using: .utf8)!)
  exit(2)
}
let jobs = try JSONDecoder().decode([RenderJob].self, from: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1])))
for job in jobs {
  try render(job: job)
}
print("RENDERED=\(jobs.count)")
