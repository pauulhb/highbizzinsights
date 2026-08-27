import '../repositories/attachment_repository.dart';

class AttachmentUploadService {
  final AttachmentRepository repo;
  AttachmentUploadService({AttachmentRepository? repo})
      : repo=repo??AttachmentRepository();

  Future<void> upload({
    required String customerId,
    String? visitId,
    required String category,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
    required Future<void> Function(String uploadUrl) binaryUploader,
  }) async {
    final intent=await repo.createUploadIntent(
      customerId:customerId,
      visitId:visitId,
      category:category,
      fileName:fileName,
      mimeType:mimeType,
    );

    final uploadUrl=intent['uploadUrl'];
    if(uploadUrl==null) throw Exception('Upload URL unavailable');

    await binaryUploader(uploadUrl);

    await repo.confirm(
      customerId:customerId,
      visitId:visitId,
      category:category,
      fileName:fileName,
      mimeType:mimeType,
      storageKey:intent['storageKey'],
    );
  }
}
