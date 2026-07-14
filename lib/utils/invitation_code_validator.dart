/// 招待コードの形式を検証する。
///
/// サーバーが払い出すコードは 8 文字で、英大文字・数字のうち紛らわしい文字(I/L/O/U/Z/0/1/2)を
/// 除いた集合(`ABCDEFGHJKMNPQRSTVWXY3456789`)のみで構成される(サーバーの createGroupInvitation の
/// ALPHABET と一致)。この関数はその集合・桁数に一致するかを判定する。
bool isValidInvitationCode(String code) {
  return RegExp(r'^[A-HJKMNP-TV-Y3-9]{8}$').hasMatch(code);
}
