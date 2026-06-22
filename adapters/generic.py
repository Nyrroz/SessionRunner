from .base import SiteAdapter

class GenericAdapter(SiteAdapter):

    name = "generic"

    def login(self):
        raise NotImplementedError

    def logout(self):
        raise NotImplementedError

    def is_logged_in(self):
        raise NotImplementedError
