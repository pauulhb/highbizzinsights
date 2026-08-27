export const DEFAULT_GEOFENCE_METERS =
  Number(process.env.DEFAULT_GEOFENCE_METERS || 200);

export function validateCapturedLocation({
  latitude,
  longitude,
  accuracyMeters,
}) {
  if (typeof latitude !== 'number' || typeof longitude !== 'number') {
    throw Object.assign(
      new Error('Device GPS latitude and longitude are required'),
      { status: 422 }
    );
  }

  if (
    latitude < -90 ||
    latitude > 90 ||
    longitude < -180 ||
    longitude > 180
  ) {
    throw Object.assign(new Error('Invalid GPS coordinates'), { status: 422 });
  }

  if (
    accuracyMeters != null &&
    (typeof accuracyMeters !== 'number' || accuracyMeters < 0)
  ) {
    throw Object.assign(new Error('Invalid GPS accuracy value'), { status: 422 });
  }
}
