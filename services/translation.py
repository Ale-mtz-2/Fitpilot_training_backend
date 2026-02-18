"""
Servicio de Traducción con Ollama (Llama 3.2)

Este servicio maneja la comunicación con Ollama para traducir
textos entre idiomas usando el modelo Llama 3.2 3B.
"""

import logging
from typing import Optional, Dict
import httpx
from functools import lru_cache

from core.config import settings

logger = logging.getLogger(__name__)


class TranslationService:
    """
    Servicio de traducción usando Ollama con Llama 3.2.
    Diseñado para traducir nombres y descripciones de ejercicios.
    """

    SUPPORTED_LANGUAGES = {"es": "Spanish", "en": "English"}

    def __init__(self):
        self.ollama_host = settings.OLLAMA_HOST
        self.model = settings.OLLAMA_MODEL
        self.timeout = 60.0  # 60 segundos máximo por traducción
        self._cache: Dict[str, str] = {}

    def _get_cache_key(self, text: str, source: str, target: str) -> str:
        """Genera una clave única para el cache."""
        return f"{source}:{target}:{text}"

    def _build_prompt(self, text: str, source_lang: str, target_lang: str) -> str:
        """
        Construye el prompt para la traducción.
        Optimizado para traducciones cortas y precisas.
        """
        source_name = self.SUPPORTED_LANGUAGES.get(source_lang, source_lang)
        target_name = self.SUPPORTED_LANGUAGES.get(target_lang, target_lang)

        return f"""Translate the following text from {source_name} to {target_name}.
Rules:
- Return ONLY the translation, nothing else
- Keep proper nouns and technical terms as-is when appropriate
- Maintain the same tone and style
- If the text is already in the target language, return it unchanged

Text to translate: {text}

Translation:"""

    async def translate(
        self,
        text: str,
        source_lang: str = "en",
        target_lang: str = "es"
    ) -> Optional[str]:
        """
        Traduce un texto de un idioma a otro.

        Args:
            text: Texto a traducir
            source_lang: Código del idioma origen (es, en)
            target_lang: Código del idioma destino (es, en)

        Returns:
            Texto traducido o None si falla
        """
        if not text or not text.strip():
            return text

        # Si origen y destino son iguales, retornar el texto original
        if source_lang == target_lang:
            return text

        # Verificar cache
        cache_key = self._get_cache_key(text, source_lang, target_lang)
        if cache_key in self._cache:
            logger.debug(f"Cache hit para traducción: {text[:30]}...")
            return self._cache[cache_key]

        try:
            prompt = self._build_prompt(text, source_lang, target_lang)

            async with httpx.AsyncClient(timeout=self.timeout) as client:
                response = await client.post(
                    f"{self.ollama_host}/api/generate",
                    json={
                        "model": self.model,
                        "prompt": prompt,
                        "stream": False,
                        "options": {
                            "temperature": 0.1,  # Baja temperatura para traducciones consistentes
                            "num_predict": 256,  # Límite de tokens de respuesta
                        }
                    }
                )

                if response.status_code == 200:
                    result = response.json()
                    translation = result.get("response", "").strip()

                    # Limpiar la respuesta (remover comillas extras si las hay)
                    translation = translation.strip('"\'')

                    if translation:
                        # Guardar en cache
                        self._cache[cache_key] = translation
                        logger.info(f"Traducido: '{text[:30]}...' -> '{translation[:30]}...'")
                        return translation
                    else:
                        logger.warning(f"Respuesta vacía de Ollama para: {text[:30]}...")
                        return text
                else:
                    logger.error(f"Error de Ollama: {response.status_code} - {response.text}")
                    return text

        except httpx.TimeoutException:
            logger.error(f"Timeout al traducir: {text[:30]}...")
            return text
        except httpx.ConnectError:
            logger.error("No se pudo conectar con Ollama. ¿Está el servicio corriendo?")
            return text
        except Exception as e:
            logger.error(f"Error inesperado en traducción: {e}")
            return text

    async def translate_exercise(
        self,
        name: str,
        description: Optional[str],
        source_lang: str = "en",
        target_lang: str = "es"
    ) -> Dict[str, Optional[str]]:
        """
        Traduce nombre y descripción de un ejercicio.

        Returns:
            Dict con 'name' y 'description' traducidos
        """
        translated_name = await self.translate(name, source_lang, target_lang)
        translated_description = None

        if description:
            translated_description = await self.translate(
                description, source_lang, target_lang
            )

        return {
            "name": translated_name,
            "description": translated_description
        }

    async def is_available(self) -> bool:
        """
        Verifica si el servicio de Ollama está disponible.
        """
        try:
            async with httpx.AsyncClient(timeout=5.0) as client:
                response = await client.get(f"{self.ollama_host}/api/tags")
                if response.status_code == 200:
                    tags = response.json()
                    models = [m.get("name", "") for m in tags.get("models", [])]
                    # Verificar si el modelo está instalado
                    model_base = self.model.split(":")[0]
                    return any(model_base in m for m in models)
                return False
        except Exception as e:
            logger.error(f"Error verificando disponibilidad de Ollama: {e}")
            return False

    def clear_cache(self):
        """Limpia el cache de traducciones."""
        self._cache.clear()
        logger.info("Cache de traducciones limpiado")


# Instancia singleton del servicio
translation_service = TranslationService()
