import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile(String url, String fileName) async {
  try {
    // Get the directory for storing the file
    final directory = await getApplicationDocumentsDirectory();
    // is used to get the directory path where the file will be stored.
    final filePath = '${directory.path}/$fileName';

    // Create a Dio instance
    Dio dio = Dio();

    // Start the download
    await dio.download(
      url,
      filePath,
      // onReceiveProgress = provides progress updates during the download.
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print('Progress: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      },
    );

    print('File downloaded to $filePath');
  } catch (e) {
    print('Error downloading file: $e');
  }
}
