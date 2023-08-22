import 'package:permission_handler/permission_handler.dart';


Future<void> requestStoragePermission() async {
  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Permiso otorgado, puedes acceder al almacenamiento aquí
  } else if (status.isDenied) {
    // Permiso denegado pero puede solicitarse nuevamente
  } else if (status.isPermanentlyDenied) {
    // Permiso denegado permanentemente, el usuario debe habilitarlo manualmente en la configuración de la aplicación
    // Open application settings to grant permissions
    await openAppSettings();
  }
}
