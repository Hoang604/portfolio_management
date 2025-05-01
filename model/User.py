import mysql.connector
# add utils to path
import sys
import os
sys.path.append("/home/hoang/python/portfolio_management")
from utils import database as db

class User:
    def __init__(self, user_id=None, name=None, contact_info=None, cash_balance=0, created_at=None, updated_at=None, update_reason=None):
        self.user_id = user_id
        self.name = name
        self.contact_info = contact_info
        self.cash_balance = cash_balance
        self.created_at = created_at
        self.updated_at = updated_at
        self.update_reason = update_reason

    def save(self, mydb=None):
        """Lưu thông tin người dùng vào CSDL (thêm mới hoặc cập nhật)."""
        if not mydb: return False
        try:
            cursor = mydb.cursor()
            if self.user_id is None:
                sql = "INSERT INTO users (name, contact_info, cash_balance) VALUES (%s, %s, %s)"
                val = (self.name, self.contact_info, self.cash_balance)
            else:
                sql = "UPDATE users SET name=%s, contact_info=%s, cash_balance=%s WHERE user_id=%s"
                val = (self.name, self.contact_info, self.cash_balance, self.user_id)
            cursor.execute(sql, val)
            mydb.commit()
            if self.user_id is None: self.user_id = cursor.lastrowid
            print(f"User save: {self.name} (ID: {self.user_id})")
            return True
        except mysql.connector.Error as err: print(f"Error when save User: {err}"); mydb.rollback(); return False

    @staticmethod
    def get_by_id(user_id, mydb=None):
        if not mydb: return None
        try:
            cursor = mydb.cursor(dictionary=True)
            cursor.execute("SELECT * FROM users WHERE user_id = %s", (user_id,))
            result = cursor.fetchone()
            return User(**result) if result else None
        except mysql.connector.Error as err: print(f"Error get_by_id User: {err}"); return None

    @staticmethod
    def get_all(mydb=None):
        if not mydb: return []
        try:
            cursor = mydb.cursor(dictionary=True)
            cursor.execute("SELECT * FROM users")
            results = cursor.fetchall()
            return [User(**row) for row in results]
        except mysql.connector.Error as err: print(f"Error get_all Users: {err}"); return []

    def delete(self, mydb=None):
        if not self.user_id: print("User don't have ID, cannot delete."); return False
        if not mydb: return False
        try:
            cursor = mydb.cursor()
            cursor.execute("DELETE FROM users WHERE user_id = %s", (self.user_id,))
            mydb.commit()
            print(f"User ID: {self.user_id} has been deleted.")
            return True
        except mysql.connector.Error as err: print(f"Error when delete User: {err}"); mydb.rollback(); return False

    def __str__(self):
        return f"User(ID: {self.user_id}, Name: {self.name}, Contact: {self.contact_info})"