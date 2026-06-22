from playwright.sync_api import Page, TimeoutError as PlaywrightTimeoutError

from adapters.base import SiteAdapter
from config.settings import USERNAME, PASSWORD


class StudiAdapter(SiteAdapter):
    """Adapter de connexion pour la plateforme Studi (SPA Angular)."""

    LOGIN_URL = "https://app.studi.fr/v3/login"

    EMAIL_SELECTOR = "input[formcontrolname='email']"
    PASSWORD_SELECTOR = "input[formcontrolname='password']"
    SUBMIT_SELECTOR = "button.login-btn"

    # On vérifie le login via l'URL plutôt qu'un selector (plus fiable sur Angular)
    DASHBOARD_URL_PATTERN = "**/dashboard**"

    def __init__(self, page: Page):
        self.page = page

    def login(self) -> bool:
        self.page.goto(self.LOGIN_URL)

        # IMPORTANT : pas de wait_for_load_state("networkidle") ici.
        # Angular ne devient quasiment jamais "network idle" (polling/analytics
        # en continu), ce qui faisait timeout après 30s avant même de remplir
        # les champs. On attend directement l'élément dont on a besoin.
        self.page.wait_for_selector(self.EMAIL_SELECTOR, timeout=15000)

        self.page.locator(self.EMAIL_SELECTOR).fill(USERNAME)
        self.page.locator(self.PASSWORD_SELECTOR).fill(PASSWORD)
        self.page.locator(self.SUBMIT_SELECTOR).click()

        return self.is_logged_in()

    def is_logged_in(self) -> bool:
        try:
            self.page.wait_for_url(self.DASHBOARD_URL_PATTERN, timeout=10000)
            return True
        except PlaywrightTimeoutError:
            return False

    def logout(self):
        # TODO: implémenter une fois le bouton/lien de logout identifié
        raise NotImplementedError("logout() pas encore implémenté pour StudiAdapter")