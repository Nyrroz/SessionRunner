from playwright.sync_api import sync_playwright


class PlaywrightClient:
    """Encapsule le cycle de vie Playwright (browser + page)."""

    def __init__(self, headless: bool = False):
        self.playwright = sync_playwright().start()
        self.browser = self.playwright.chromium.launch(headless=headless)
        self.page = self.browser.new_page()

    def close(self):
        self.browser.close()
        self.playwright.stop()