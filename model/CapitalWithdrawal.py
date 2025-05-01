import mysql.connector

class CapitalWithdrawal:
    def __init__(self, capital_withdrawal_id=None, user_id=None, withdrawal_date=None, amount=None, description=None, created_at=None, updated_at=None):
        self.capital_withdrawal_id = capital_withdrawal_id
        self.user_id = user_id
        self.withdrawal_date = withdrawal_date # Should use datetime.date object
        self.amount = amount
        self.description = description
        self.created_at = created_at
        self.updated_at = updated_at
    
    def save(self, db):
        if db is None: return False
        try:
            cursor = db.cursor()
            if self.capital_withdrawal_id is None:
                sql = "INSERT INTO capital_withdrawals (user_id, withdrawal_date, amount, description) VALUES (%s, %s, %s, %s)"
                val = (self.user_id, self.withdrawal_date, self.amount, self.description)
            else:
                sql = "UPDATE capital_withdrawals SET user_id=%s, withdrawal_date=%s, amount=%s, description=%s WHERE capital_withdrawal_id=%s"
                val = (self.user_id, self.withdrawal_date, self.amount, self.description, self.capital_withdrawal_id)
            cursor.execute(sql, val)
            db.commit()
            if self.capital_withdrawal_id is None: self.capital_withdrawal_id = cursor.lastrowid
            print(f"CapitalWithdrawal saved (ID: {self.capital_withdrawal_id})")
            return True
        except mysql.connector.Error as err: print(f"Error saving CapitalWithdrawal: {err}"); db.rollback(); return False