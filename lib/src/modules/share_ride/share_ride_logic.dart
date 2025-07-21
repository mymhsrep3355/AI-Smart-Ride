import 'package:url_launcher/url_launcher.dart';

class ShareRideController {
  final String driverName = "Abdullah";
  final String vehicleInfo = "B 1234 EA - Green Auto";
  final String trackingURL = "https://www.uber.com/track/abcdef123456";

  // Replace these dynamically in real implementation
  final String pickupAddress = "Gulshan-e-Iqbal Block 5, Karachi";
  final String dropoffAddress = "DHA Phase 6, Karachi";

  /// Opens the ride tracking URL in browser
  void openTrackingURL() async {
    final url = Uri.parse(trackingURL);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $trackingURL";
    }
  }

  /// Shares ride info via WhatsApp
  void sendToWhatsApp() async {
    final message = Uri.encodeComponent(
      "📍 *Ride Details*\n\n"
      "🚖 *Driver:* $driverName\n"
      "🚗 *Vehicle:* $vehicleInfo\n"
      "📌 *Pickup:* $pickupAddress\n"
      "📍 *Dropoff:* $dropoffAddress\n"
      "🔗 *Track Ride:* $trackingURL"
    );

    final whatsappUrl = Uri.parse("https://wa.me/?text=$message");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      throw "Could not launch WhatsApp";
    }
  }
}
