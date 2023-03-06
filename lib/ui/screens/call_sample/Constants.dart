enum WebRTCSessionState {
  Active, // Offer and Answer messages has been sent
  Creating, // Creating session, offer has been sent
  Ready, // Both clients available and ready to initiate session
  Impossible, // We have less than two clients connected to the server
  Offline // unable to connect signaling server
}

enum SignalingCommand {
  STATE, // Command for WebRTCSessionState
  OFFER, // to send or receive offer
  ANSWER, // to send or receive answer
  ICE // to send and receive ice candidates
}

enum Type { OFFER, PRANSWER, ANSWER, ROLLBACK }

extension TypeExtensions on Type {
  String get canonicalForm => toString().toLowerCase();

  static Type fromCanonicalForm(String canonical) {
    return Type.values.firstWhere((e) => e.canonicalForm == canonical.toLowerCase());
  }
}

var ICE_SEPARATOR = '\$';

extension StringExtension on String {
  String mungeCodecs() {
    return this.replaceFirst("vp9", "VP9").replaceFirst("vp8", "VP8").replaceFirst("h264", "H264");
  }
}
