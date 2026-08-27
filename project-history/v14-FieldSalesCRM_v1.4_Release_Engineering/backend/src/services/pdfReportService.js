import {pdfAdapter} from './pdfAdapter.js';

export async function buildPerformancePdf(payload) {
  return pdfAdapter().render({
    title:'Field Sales Performance Report',
    generatedAt:new Date().toISOString(),
    payload
  });
}
