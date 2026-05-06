class EntityConfig:
    def __init__(self):
        self.entities = {
            "customers": {
                "primary_key": "customer_id",
                "cdc": True,
                "scd_type2": True
            },
            "accounts": {
                "primary_key": "account_id",
                "cdc": True,
                "scd_type2": True
            },
            "transactions": {
                "primary_key": "transaction_id",
                "cdc": False,
                "scd_type2": False
            }
        }
