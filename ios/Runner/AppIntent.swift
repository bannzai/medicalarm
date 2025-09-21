import Foundation
import AppIntents

@available(iOS 16.0, *)
struct TakeMedicineIntent: AppIntent {
    static var title: LocalizedStringResource = "服薬記録"
    static var description: IntentDescription = IntentDescription("薬を飲んだことを記録します")
    
    @Parameter(title: "薬の名前", description: "服用した薬の名前")
    var medicineName: String?
    
    func perform() async throws -> some IntentResult {
        // ここで実際の服薬記録処理を行う
        // Flutter側でのMethod Channelを通じて処理することも可能
        
        let message = if let medicineName = medicineName, !medicineName.isEmpty {
            "\(medicineName)を服用しました"
        } else {
            "薬を服用しました"
        }
        
        return .result(dialog: IntentDialog(message))
    }
}

@available(iOS 16.0, *)
struct StopAlarmIntent: AppIntent {
    static var title: LocalizedStringResource = "アラーム停止"
    static var description: IntentDescription = IntentDescription("全てのアラームを停止します")
    
    func perform() async throws -> some IntentResult {
        guard #available(iOS 18.0, *) else {
            return .result(dialog: IntentDialog("AlarmKitはiOS 18以降で利用可能です"))
        }
        
        let success = await AlarmKitManager.stopAllAlarmKitAlarms()
        
        let message = success ? "アラームを停止しました" : "アラームの停止に失敗しました"
        return .result(dialog: IntentDialog(message))
    }
}

@available(iOS 16.0, *)
struct ViewMedicinesIntent: AppIntent {
    static var title: LocalizedStringResource = "薬一覧表示"
    static var description: IntentDescription = IntentDescription("登録されている薬の一覧を表示します")
    
    func perform() async throws -> some IntentResult {
        // アプリを開いて薬一覧画面を表示
        return .result(opensIntent: OpenAppIntent())
    }
}

@available(iOS 16.0, *)
struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Medicalarmを開く"
    static var description: IntentDescription = IntentDescription("Medicalarmアプリを開きます")
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
    
    static var openAppWhenRun: Bool = true
}

@available(iOS 16.0, *)
struct MedicalarmShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: TakeMedicineIntent(),
            phrases: ["薬を飲んだ", "服薬記録", "\(.applicationName)で薬を記録"],
            shortTitle: "服薬記録",
            systemImageName: "pills.fill"
        )
        
        AppShortcut(
            intent: StopAlarmIntent(),
            phrases: ["アラーム停止", "\(.applicationName)のアラームを止めて"],
            shortTitle: "アラーム停止",
            systemImageName: "alarm"
        )
        
        AppShortcut(
            intent: ViewMedicinesIntent(),
            phrases: ["薬一覧", "薬を見る", "\(.applicationName)を開いて薬を見る"],
            shortTitle: "薬一覧",
            systemImageName: "list.bullet"
        )
    }
}