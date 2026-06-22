import logging
import signal
import sys

from browser.playwright_client import PlaywrightClient
from adapters.studi import StudiAdapter
from config.settings import HEADLESS

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)

_shutdown_requested = False


def _handle_signal(signum, frame):
    global _shutdown_requested
    logger.info("Signal %s reçu, arrêt demandé.", signum)
    _shutdown_requested = True


def main():
    # SIGTERM = ce que `docker stop` envoie. SIGINT = Ctrl+C en local.
    signal.signal(signal.SIGTERM, _handle_signal)
    signal.signal(signal.SIGINT, _handle_signal)

    client = PlaywrightClient(headless=HEADLESS)
    adapter = StudiAdapter(client.page)

    if not adapter.login():
        logger.error("Connexion échouée, arrêt.")
        try:
            client.close()
        except Exception:
            logger.exception("Erreur lors de la fermeture du client après échec de login")
        # login failed -> non-zero exit code required by spec
        sys.exit(1)

    logger.info("Session active. En attente d'un signal d'arrêt (SIGTERM/SIGINT)...")

    # Pas de boucle de polling, pas de refresh : le process dort jusqu'au
    # prochain signal. Zéro CPU consommé pendant l'attente.
    while not _shutdown_requested:
        signal.pause()

    logger.info("Fermeture propre de la session.")
    try:
        client.close()
    except Exception:
        # On logge l'exception mais on considère que le shutdown réussi
        # du point de vue du scheduler (exit code 0 attendu).
        logger.exception("Erreur lors de la fermeture du client pendant le shutdown")

    # exit 0 = arrêt propre après login OK
    sys.exit(0)


if __name__ == "__main__":
    main()
