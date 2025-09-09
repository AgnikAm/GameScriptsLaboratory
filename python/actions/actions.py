from typing import Any, Text, Dict, List
import re
import os
from rasa_sdk import Action, Tracker, FormValidationAction
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict

PHONE_RE = re.compile(r"^[0-9+]{6,15}$")
BASE_PATH = os.path.dirname(__file__)

class ValidateDeliveryForm(FormValidationAction):
    def name(self) -> Text:
        return "validate_delivery_form"

    def slot_mappings(self) -> Dict[Text, List[Dict[Text, Any]]]:
        return {
            "order_items": [self.from_text()],
            "address": [self.from_text()],
            "name": [self.from_text()],
            "phone": [self.from_text()],
        }

    async def validate_order_items(self, value, dispatcher, tracker, domain):
        if len(value) >= 2:
            return {"order_items": value}
        dispatcher.utter_message(text="Please provide what you'd like to order.")
        return {"order_items": None}

    async def validate_address(self, value, dispatcher, tracker, domain):
        if len(value) >= 5:
            return {"address": value}
        dispatcher.utter_message(text="Please enter a valid delivery address.")
        return {"address": None}

    async def validate_name(self, value, dispatcher, tracker, domain):
        if len(value) >= 2:
            return {"name": value}
        dispatcher.utter_message(text="Please enter a name with at least 2 characters.")
        return {"name": None}

    async def validate_phone(self, value, dispatcher, tracker, domain):
        if PHONE_RE.match(value):
            return {"phone": value}
        dispatcher.utter_message(text="Please enter a valid phone number.")
        return {"phone": None}


class ActionShowMenu(Action):
    def name(self) -> Text:
        return "action_show_menu"

    async def run(self, dispatcher: CollectingDispatcher,
                  tracker: Tracker,
                  domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        menu_path = os.path.join(BASE_PATH, "menu.txt")
        try:
            with open(menu_path, "r", encoding="utf-8") as f:
                menu = f.read()
        except:
            menu = "Sorry, menu is unavailable."
        dispatcher.utter_message(text="Today's menu:\n" + menu)
        return []


class ActionOpeningHours(Action):
    def name(self) -> Text:
        return "action_opening_hours"

    async def run(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: Dict[Text, Any]
    ) -> List[Dict[Text, Any]]:

        hours_path = os.path.join(BASE_PATH, "opening_hours.txt")

        if os.path.exists(hours_path):
            try:
                with open(hours_path, "r", encoding="utf-8") as f:
                    hours_content = f.read().strip()
                if not hours_content:
                    hours_content = "Sorry, opening hours information is currently empty."
            except Exception:
                hours_content = "Sorry, opening hours are unavailable at the moment."
        else:
            hours_content = "Sorry, opening hours file not found."

        dispatcher.utter_message(text=f"Opening hours:\n{hours_content}")
        return []


class ActionSubmitDelivery(Action):
    def name(self) -> Text:
        return "action_submit_delivery"

    async def run(
        self,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict
    ) -> List[Dict[Text, Any]]:

        order_items = tracker.get_slot("order_items") or "Not specified"
        address = tracker.get_slot("address") or "Not specified"
        name = tracker.get_slot("name") or "Not specified"
        phone = tracker.get_slot("phone") or "Not specified"

        summary = (
            "📦 **Delivery Order Summary** 📦\n"
            f"- Order items: {order_items}\n"
            f"- Delivery address: {address}\n"
            f"- Name: {name}\n"
            f"- Phone: {phone}"
        )

        dispatcher.utter_message(text=summary)
        dispatcher.utter_message(text="✅ Thank you! We will process your delivery shortly.")

        return []

