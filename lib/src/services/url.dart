String baseUrl = 'http://192.168.18.142:3000/api/v1';

final String driverRegister = '$baseUrl/driver/register';

final String driverVerify = '$baseUrl/driver/verify';
final String driverSetPassword = '$baseUrl/driver/setPassword';

final String driverLogin = '$baseUrl/driver/login';
final String driverInfo = '$baseUrl/driver/onboarding/details';
final String driverSelfie = '$baseUrl/driver/onboarding/selfie';
final String driverLicenseUpload = '$baseUrl/driver/upload/license';
final String driverVehicleSelection = '$baseUrl/driver/onboarding/vehicle';
final String driverForgotPassword = '$baseUrl/driver/forgotPassword';
final String driverForgotPasswordVerification = '$baseUrl/driver/verifyReset';
final String driverResetPassword = '$baseUrl/driver/resetPasswordWithToken';
final String passengerRegister = '$baseUrl/passenger/register';
final String passengerVerify = '$baseUrl/passenger/verify';
final String passengerSetPassword = '$baseUrl/passenger/setPassword';
final String passengerLogin = '$baseUrl/passenger/login';
final String passengerLogout = '$baseUrl/passenger/logout';
final String passengerDelete = '$baseUrl/passenger/delete';
final String creategroup = '$baseUrl/chat/groups';
final String getGroupsURL = '$baseUrl/chat/groups'; // Backend must support GET
String joinGroupURL(String groupId) => '$baseUrl/chat/groups/join/$groupId';
String groupchatsURL(String groupId) =>
    '$baseUrl/chat/groups/messages/$groupId';
final String passengercreateRides = '$baseUrl/passenger/rides';
final String getpassengercreateRides = '$baseUrl/passenger/rides';
final String getdriverAvailableRides = '$baseUrl/driver/rides/available';
String driverrejectRides(String rideId) =>
    "$baseUrl/driver/rides/reject/$rideId";
String acceptRideURL(String rideId) => "$baseUrl/driver/rides/accept/$rideId";
final String passengerRides = '$baseUrl/passenger/rides';
String passengerAcceptRideURL(String rideId) =>
    "$baseUrl/passenger/rides/accept/$rideId";
String passengerCancelRide(String rideId) =>
    "$baseUrl/passenger/rides/cancel/$rideId";
String driverArriveRide(String rideId) =>
    '$baseUrl/driver/rides/arrive/$rideId';
String driverCancelRide(String rideId) =>
    '$baseUrl/driver/rides/cancel/$rideId';
String leaveGroupURL(String groupId) => '$baseUrl/chat/groups/leave/$groupId';
String leaveGroup(String groupId) => '$baseUrl/chat/groups/leave/$groupId';
String bookRideURL(String groupId) => "$baseUrl/chat/groups/bookRide/$groupId";
String passengerComingRide(String rideId) =>
    "$baseUrl/passenger/ride/coming/$rideId";
String passengerReviewRide(String rideId) =>
    "$baseUrl/passenger/rides/review/$rideId";
String driverStartRide(String rideId) => "$baseUrl/driver/rides/start/$rideId";
String driverEndRide(String rideId) => "$baseUrl/driver/rides/end/$rideId";

final String logoutAccount = '$baseUrl/driver/logout';
final String delete = '$baseUrl/driver/delete';
