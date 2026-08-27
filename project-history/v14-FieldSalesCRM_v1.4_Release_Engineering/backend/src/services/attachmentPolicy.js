const allowedMime = new Set([
  'application/pdf',
  'image/jpeg',
  'image/png'
]);

export function validateAttachment({mimeType,sizeBytes}) {
  if(!allowedMime.has(mimeType)) {
    throw Object.assign(new Error('Unsupported file type'),{status:422});
  }
  if(sizeBytes > 10*1024*1024) {
    throw Object.assign(new Error('File exceeds 10 MB limit'),{status:422});
  }
}
