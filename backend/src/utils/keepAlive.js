const DEFAULT_INTERVAL_MS = 13 * 60 * 1000;

const keepAlive = ({ url, interval } = {}) => {
  if (!url) {
    console.warn('[keep-alive] Missing KEEP_ALIVE_URL, skipping warm-up pings');
    return;
  }

  const intervalMs = Number(interval) || DEFAULT_INTERVAL_MS;

  const ping = async () => {
    const start = Date.now();
    try {
      const response = await fetch(url, { method: 'GET', cache: 'no-store' });
      const duration = Date.now() - start;
      console.log(
        `[keep-alive] pinged ${url} status=${response.status} time=${duration}ms`
      );
    } catch (error) {
      const duration = Date.now() - start;
      console.warn(
        `[keep-alive] ping to ${url} failed after ${duration}ms error=${error.message}`
      );
    }
  };

  // Give the server a moment to finish booting before the first ping
  setTimeout(ping, 1000);
  setInterval(ping, intervalMs);
};

export default keepAlive;
