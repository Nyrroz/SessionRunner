from abc import ABC, abstractmethod


class SiteAdapter(ABC):
    """Interface commune à tous les adapters de site (Studi, Moodle, etc.)."""

    @abstractmethod
    def login(self) -> bool:
        """Tente une connexion. Retourne True si réussie, False sinon."""
        ...

    @abstractmethod
    def is_logged_in(self) -> bool:
        """Vérifie l'état de connexion courant."""
        ...

    @abstractmethod
    def logout(self):
        """Déconnecte la session courante."""
        ...