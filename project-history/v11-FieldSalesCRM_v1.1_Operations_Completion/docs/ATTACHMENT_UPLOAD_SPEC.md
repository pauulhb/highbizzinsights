# Attachment Upload Specification

Supported business attachments:
- Purchase Order
- Quotation
- Business Card
- Customer Document

Recommended production flow:
1. Mobile requests signed upload URL.
2. Backend authorizes customer/visit access.
3. Mobile uploads binary directly to object storage.
4. Mobile submits attachment metadata.
5. Backend stores object key, checksum and audit event.
6. Download uses short-lived signed URL.

Do not store large binaries directly in PostgreSQL.
