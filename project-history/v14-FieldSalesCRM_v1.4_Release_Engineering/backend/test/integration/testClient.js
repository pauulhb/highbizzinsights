export async function api(path, {
  method='GET',
  token,
  body,
  baseUrl=process.env.TEST_API_BASE_URL || 'http://localhost:8080/v1'
} = {}) {
  const r = await fetch(`${baseUrl}${path}`, {
    method,
    headers: {
      'Content-Type':'application/json',
      ...(token ? {Authorization:`Bearer ${token}`} : {})
    },
    body: body ? JSON.stringify(body) : undefined
  });

  let payload = null;
  try { payload = await r.json(); } catch {}

  return {status:r.status, body:payload};
}
