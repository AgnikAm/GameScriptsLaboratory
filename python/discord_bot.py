import os
from typing import List, Dict, Any

import aiohttp
import discord
from discord import Intents
from dotenv import load_dotenv

load_dotenv()

DISCORD_TOKEN = os.getenv("DISCORD_TOKEN")
RASA_URL = os.getenv("RASA_URL", "http://localhost:5005")

if not DISCORD_TOKEN:
    raise RuntimeError("No Discord token in (.env).")

intents = Intents.default()
intents.message_content = True

class RasaDiscordClient(discord.Client):
    def __init__(self, *, rasa_url: str, **options: Any):
        super().__init__(intents=intents, **options)
        self.rasa_url = rasa_url.rstrip("/")

    async def on_ready(self):
        print(f"Logged as {self.user} (id: {self.user.id})")
        print("Ready to chat!")

    async def send_to_rasa(self, sender: str, text: str) -> List[Dict[str, Any]]:
        url = f"{self.rasa_url}/webhooks/rest/webhook"
        payload = {"sender": sender, "message": text}
        async with aiohttp.ClientSession() as session:
            async with session.post(url, json=payload, timeout=30) as resp:
                if resp.status != 200:
                    body = await resp.text()
                    raise RuntimeError(f"Rasa REST error {resp.status}: {body}")
                return await resp.json()

    async def on_message(self, message: discord.Message):
        if message.author.id == self.user.id:
            return
        if message.author.bot:
            return

        text = message.content.strip()
        if not text:
            return

        sender_id = f"{message.author.id}-{message.channel.id}"

        async with message.channel.typing():
            try:
                responses = await self.send_to_rasa(sender_id, text)
            except Exception as e:
                await message.channel.send(f"Ups, nie mogę połączyć się z Rasa: {e}")
                return

        for r in responses:
            if "text" in r:
                await message.channel.send(r["text"])
            if "image" in r:
                await message.channel.send(r["image"])

def main():
    client = RasaDiscordClient(rasa_url=RASA_URL)
    client.run(DISCORD_TOKEN)

if __name__ == "__main__":
    main()
