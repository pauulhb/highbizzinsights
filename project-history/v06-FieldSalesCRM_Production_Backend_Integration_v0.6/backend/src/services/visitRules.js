export const MIN_QUALIFIED_SECONDS =
  Number(process.env.MIN_QUALIFIED_VISIT_SECONDS || 900);

export const DEFAULT_GEOFENCE_METERS =
  Number(process.env.DEFAULT_GEOFENCE_METERS || 200);

export function qualifyVisit(durationSeconds, shortVisitReason) {
  const qualified = durationSeconds >= MIN_QUALIFIED_SECONDS;

  if (!qualified && !shortVisitReason) {
    const error = new Error('Short visit reason is required below 15 minutes');
    error.status = 422;
    throw error;
  }

  return qualified;
}

export function haversineMeters(lat1, lon1, lat2, lon2) {
  const R = 6371000;
  const toRad = (d) => d * Math.PI / 180;
  const p1 = toRad(lat1);
  const p2 = toRad(lat2);
  const dp = toRad(lat2 - lat1);
  const dl = toRad(lon2 - lon1);

  const a =
    Math.sin(dp / 2) ** 2 +
    Math.cos(p1) * Math.cos(p2) * Math.sin(dl / 2) ** 2;

  return 2 * R * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}
