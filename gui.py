import tkinter as tk
from tkinter import ttk
from tkinter import font as tkFont # Import font module
from icecream import ic

class PortfolioApp(tk.Tk):
    def __init__(self, controller):
        super().__init__()
        self.controller = controller # Nhận controller instance
        self.title("Investment Portfolio Management")

        # --- Configure Font Size ---
        default_font = tkFont.Font(family="Ubuntu Medium")
        default_font.configure(size=16)
        self.option_add("*Font", default_font)

        # --- Configure ttk style for larger font ---
        style = ttk.Style(self)
        style.configure('.', font=default_font) # Apply default font to all ttk widgets
        style.configure('TNotebook.Tab', font=(default_font.name, 15)) # Slightly smaller bold font for tabs

        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill='both', expand=True)

        self.user_tab = UserTab(self.notebook, controller=self.controller)
        self.stock_tab = StockTab(self.notebook, controller=self.controller)
        self.capital_tab = CapitalInjectionTab(self.notebook, controller=self.controller)
        self.transaction_tab = TransactionTab(self.notebook, controller=self.controller)
        self.dividen_tab = DividenTab(self.notebook, controller=self.controller)
        self.withdrawal_tab = CapitalWithdrawalTab(self.notebook, controller=self.controller)

        self.notebook.add(self.user_tab, text="Add new User")
        self.notebook.add(self.stock_tab, text="Add new Stock")
        self.notebook.add(self.capital_tab, text="Capital Injection")
        self.notebook.add(self.transaction_tab, text="Transaction")
        self.notebook.add(self.dividen_tab, text="Dividend")
        self.notebook.add(self.withdrawal_tab, text="Capital Withdrawal")

# ----- Tab Add new User -----
class UserTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        # Use ttk widgets for consistent styling
        ttk.Label(self, text="Name:").grid(row=0, column=0, padx=10, pady=10, sticky='w')
        self.user_name_entry = ttk.Entry(self)
        self.user_name_entry.grid(row=0, column=1, padx=10, pady=10, sticky='ew')
        ttk.Label(self, text="Contact Info:").grid(row=1, column=0, padx=10, pady=10, sticky='w')
        self.user_contact_entry = ttk.Entry(self)
        self.user_contact_entry.grid(row=1, column=1, padx=10, pady=10, sticky='ew')
        ttk.Button(self, text="Save User",
                   command=self.save_user_action).grid(row=2, column=0, columnspan=2, pady=10)
        self.columnconfigure(1, weight=1) # Allow entry to expand

    def save_user_action(self):
        name = self.user_name_entry.get()
        contact_info = self.user_contact_entry.get()
        self.controller.save_user(name, contact_info) # Gọi controller method
        # Clear entries after saving
        self.user_name_entry.delete(0, tk.END)
        self.user_contact_entry.delete(0, tk.END)
        # Add user feedback (optional)
        # tk.messagebox.showinfo("Success", "User saved successfully!")

# ----- Tab Add new Stock -----
class StockTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        # Use ttk widgets
        ttk.Label(self, text="Stock Code:").grid(row=0, column=0, padx=10, pady=10, sticky='w')
        self.stock_code_entry = ttk.Entry(self)
        self.stock_code_entry.grid(row=0, column=1, padx=10, pady=10, sticky='ew')
        ttk.Label(self, text="Company Name:").grid(row=1, column=0, padx=10, pady=10, sticky='w')
        self.company_name_entry = ttk.Entry(self)
        self.company_name_entry.grid(row=1, column=1, padx=10, pady=10, sticky='ew')
        ttk.Button(self, text="Save Stock",
                   command=self.save_stock_action).grid(row=2, column=0, columnspan=2, pady=10)
        self.columnconfigure(1, weight=1) # Allow entry to expand

    def save_stock_action(self):
        stock_code = self.stock_code_entry.get()
        company_name = self.company_name_entry.get()
        self.controller.save_stock(stock_code, company_name) # Gọi controller method
        # Clear entries
        self.stock_code_entry.delete(0, tk.END)
        self.company_name_entry.delete(0, tk.END)
        # Add feedback (optional)
        # tk.messagebox.showinfo("Success", "Stock saved successfully!")
        # Refresh dropdowns in other tabs if necessary
        self.master.master.transaction_tab.refresh_stock_dropdown()
        self.master.master.dividen_tab.refresh_stock_dropdown()


# ----- Tab Capital Injection -----
class CapitalInjectionTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        # Use ttk widgets
        ttk.Label(self, text="Select User:").grid(row=0, column=0, padx=10, pady=10, sticky='w')
        self.capital_user_combo, self.get_capital_user_id = self.create_user_dropdown(self)
        self.capital_user_combo.grid(row=0, column=1, padx=10, pady=10, sticky='ew')
        ttk.Label(self, text="Amount:").grid(row=1, column=0, padx=10, pady=10, sticky='w')
        self.capital_amount_entry = ttk.Entry(self)
        self.capital_amount_entry.grid(row=1, column=1, padx=10, pady=10, sticky='ew')
        ttk.Label(self, text="Description:").grid(row=2, column=0, padx=10, pady=10, sticky='w')
        self.capital_desc_entry = ttk.Entry(self)
        self.capital_desc_entry.grid(row=2, column=1, padx=10, pady=10, sticky='ew')
        ttk.Label(self, text="Injection Date:").grid(row=3, column=0, padx=10, pady=10, sticky='w')
        self.capital_date_entry = ttk.Entry(self) # Consider using a DateEntry widget later
        self.capital_date_entry.grid(row=3, column=1, padx=10, pady=10, sticky='ew')
        ttk.Button(self, text="Save Capital Injection",
                   command=self.save_capital_injection_action).grid(row=4, column=0, columnspan=2, pady=10)
        self.columnconfigure(1, weight=1) # Allow entry/combo to expand

    def save_capital_injection_action(self):
        user_info = self.get_capital_user_id()
        if not user_info or user_info[1] is None:
            # Add error handling (e.g., messagebox)
            print("Error: Please select a user.")
            return
        user_id = user_info[1]
        amount = self.capital_amount_entry.get()
        description = self.capital_desc_entry.get()
        injection_date = self.capital_date_entry.get()
        # Add validation for amount and date
        self.controller.save_capital_injection(user_id, amount, description, injection_date) # Gọi controller method
        # Clear entries
        self.capital_amount_entry.delete(0, tk.END)
        self.capital_desc_entry.delete(0, tk.END)
        self.capital_date_entry.delete(0, tk.END)
        if self.capital_user_combo['values']: # Reset combobox if it has values
             self.capital_user_combo.current(0)
        # Add feedback (optional)

    def create_user_dropdown(self, parent):
        users_dict = self.controller.get_users_dropdown_data() # Lấy data từ controller
        user_names = list(users_dict.keys()) if users_dict else []

        user_combo = ttk.Combobox(parent, values=user_names, state='readonly')
        if user_names:
            user_combo.set(user_names[0])
        else:
            user_combo.set("No users available") # Placeholder text

        def get_selected_user():
            selected_name = user_combo.get()
            if selected_name == "No users available" or not users_dict:
                return None, None
            return selected_name, users_dict.get(selected_name)

        return user_combo, get_selected_user

    def refresh_user_dropdown(self):
        users_dict = self.controller.get_users_dropdown_data()
        user_names = list(users_dict.keys()) if users_dict else []
        self.capital_user_combo['values'] = user_names
        if user_names:
            self.capital_user_combo.set(user_names[0])
            self.capital_user_combo.config(state='readonly')
        else:
            self.capital_user_combo.set("No users available")
            self.capital_user_combo.config(state='disabled') # Disable if no users

# ----- Tab Capital Withdrawal -----
class CapitalWithdrawalTab(ttk.Frame):
    def __init__ (self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        # Use ttk widgets
        ttk.Label(self, text="Select User:").grid(row=0, column=0, padx=10, pady=10, sticky='w')
        self.capital_user_combo, self.get_capital_user_id = self.create_user_dropdown(self)
        self.capital_user_combo.grid(row=0, column=1, padx=10, pady=10, sticky='ew')
        ttk.Label(self, text="Amount:").grid(row=1, column=0, padx=10, pady=10, sticky='w')
        self.capital_amount_entry = ttk.Entry(self)
        self.capital_amount_entry.grid(row=1, column=1, padx=10, pady=10, sticky='ew')
        ttk.Label(self, text="Description:").grid(row=2, column=0, padx=10, pady=10, sticky='w')
        self.capital_desc_entry = ttk.Entry(self)
        self.capital_desc_entry.grid(row=2, column=1, padx=10, pady=10, sticky='ew')
        ttk.Label(self, text="Withdrawal Date:").grid(row=3, column=0, padx=10, pady=10, sticky='w')
        self.capital_date_entry = ttk.Entry(self) # Consider DateEntry
        self.capital_date_entry.grid(row=3, column=1, padx=10, pady=10, sticky='ew')
        ttk.Button(self, text="Save Capital Withdrawal",
                   command=self.save_capital_withdrawal_action).grid(row=4, column=0, columnspan=2, pady=10)
        self.columnconfigure(1, weight=1) # Allow entry/combo to expand

    # Re-use create_user_dropdown from CapitalInjectionTab (or move to a common place)
    def create_user_dropdown(self, parent):
        users_dict = self.controller.get_users_dropdown_data() # Lấy data từ controller
        user_names = list(users_dict.keys()) if users_dict else []

        user_combo = ttk.Combobox(parent, values=user_names, state='readonly')
        if user_names:
            user_combo.set(user_names[0])
        else:
            user_combo.set("No users available")

        def get_selected_user():
            selected_name = user_combo.get()
            if selected_name == "No users available" or not users_dict:
                return None, None
            return selected_name, users_dict.get(selected_name)

        return user_combo, get_selected_user

    def refresh_user_dropdown(self):
        users_dict = self.controller.get_users_dropdown_data()
        user_names = list(users_dict.keys()) if users_dict else []
        self.capital_user_combo['values'] = user_names
        if user_names:
            self.capital_user_combo.set(user_names[0])
            self.capital_user_combo.config(state='readonly')
        else:
            self.capital_user_combo.set("No users available")
            self.capital_user_combo.config(state='disabled')

    def save_capital_withdrawal_action(self):
        user_info = self.get_capital_user_id()
        if not user_info or user_info[1] is None:
            # Add error handling
            print("Error: Please select a user.")
            return
        user_id = user_info[1]
        amount = self.capital_amount_entry.get()
        description = self.capital_desc_entry.get()
        withdrawal_date = self.capital_date_entry.get()
        # Add validation
        self.controller.save_capital_withdrawal(user_id, amount, description, withdrawal_date)
        # Clear entries
        self.capital_amount_entry.delete(0, tk.END)
        self.capital_desc_entry.delete(0, tk.END)
        self.capital_date_entry.delete(0, tk.END)
        if self.capital_user_combo['values']:
            self.capital_user_combo.current(0)
        # Add feedback (optional)

# ----- Tab Transaction -----
class TransactionTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        # Use ttk widgets
        ttk.Label(self, text="Select User:").grid(row=0, column=0, padx=10, pady=5, sticky='w')
        self.txn_user_combo, self.get_txn_user = self.create_user_dropdown(self)
        self.txn_user_combo.grid(row=0, column=1, padx=10, pady=5, sticky='ew')
        ttk.Label(self, text="Select Stock:").grid(row=1, column=0, padx=10, pady=5, sticky='w')
        self.txn_stock_combo, self.get_txn_stock_code = self.create_stock_dropdown(self)
        self.txn_stock_combo.grid(row=1, column=1, padx=10, pady=5, sticky='ew')
        ttk.Label(self, text="Transaction Date:").grid(row=2, column=0, padx=10, pady=5, sticky='w')
        self.txn_date_entry = ttk.Entry(self) # Consider DateEntry
        self.txn_date_entry.grid(row=2, column=1, padx=10, pady=5, sticky='ew')
        ttk.Label(self, text="Transaction Type:").grid(row=3, column=0, padx=10, pady=5, sticky='w')
        self.txn_type_combo = ttk.Combobox(self, values=['BUY', 'SELL'], state='readonly')
        self.txn_type_combo.set('BUY')
        self.txn_type_combo.grid(row=3, column=1, padx=10, pady=5, sticky='ew')
        ttk.Label(self, text="Quantity:").grid(row=4, column=0, padx=10, pady=5, sticky='w')
        self.txn_quantity_entry = ttk.Entry(self)
        self.txn_quantity_entry.grid(row=4, column=1, padx=10, pady=5, sticky='ew')
        ttk.Label(self, text="Price:").grid(row=5, column=0, padx=10, pady=5, sticky='w')
        self.txn_price_entry = ttk.Entry(self)
        self.txn_price_entry.grid(row=5, column=1, padx=10, pady=5, sticky='ew')
        ttk.Button(self, text="Save Transaction",
                   command=self.save_transaction_action).grid(row=6, column=0, columnspan=2, pady=10)
        self.columnconfigure(1, weight=1) # Allow entry/combo to expand

    def save_transaction_action(self):
        user_info = self.get_txn_user()
        stock_code = self.get_txn_stock_code()
        if not user_info or user_info[1] is None:
            print("Error: Please select a user.")
            return
        if not stock_code or stock_code == "No stocks available":
             print("Error: Please select a stock.")
             return

        user_id = user_info[1]
        transaction_date = self.txn_date_entry.get()
        transaction_type = self.txn_type_combo.get()
        quantity = self.txn_quantity_entry.get()
        price = self.txn_price_entry.get()
        # Add validation for date, quantity, price
        self.controller.save_transaction(user_id, stock_code, transaction_date, transaction_type, quantity, price) # Gọi controller method
        # Clear entries
        self.txn_date_entry.delete(0, tk.END)
        self.txn_quantity_entry.delete(0, tk.END)
        self.txn_price_entry.delete(0, tk.END)
        self.txn_type_combo.set('BUY')
        if self.txn_user_combo['values']:
            self.txn_user_combo.current(0)
        if self.txn_stock_combo['values']:
            self.txn_stock_combo.current(0)
        # Add feedback (optional)

    # Re-use create_user_dropdown
    def create_user_dropdown(self, parent):
        users_dict = self.controller.get_users_dropdown_data() # Lấy data từ controller
        user_names = list(users_dict.keys()) if users_dict else []

        user_combo = ttk.Combobox(parent, values=user_names, state='readonly')
        if user_names:
            user_combo.set(user_names[0])
        else:
            user_combo.set("No users available")

        def get_selected_user():
            selected_name = user_combo.get()
            if selected_name == "No users available" or not users_dict:
                return None, None
            return selected_name, users_dict.get(selected_name)

        return user_combo, get_selected_user

    def create_stock_dropdown(self, parent):
        stock_codes = self.controller.get_stocks_dropdown_data() # Lấy data từ controller
        stock_codes = stock_codes if stock_codes else []
        stock_combo = ttk.Combobox(parent, values=stock_codes, state='readonly')
        if stock_codes:
            stock_combo.set(stock_codes[0])
        else:
            stock_combo.set("No stocks available")

        def get_selected_stock_code():
            selected_code = stock_combo.get()
            if selected_code == "No stocks available":
                return None
            return selected_code

        return stock_combo, get_selected_stock_code

    def refresh_user_dropdown(self):
        users_dict = self.controller.get_users_dropdown_data()
        user_names = list(users_dict.keys()) if users_dict else []
        self.txn_user_combo['values'] = user_names
        if user_names:
            self.txn_user_combo.set(user_names[0])
            self.txn_user_combo.config(state='readonly')
        else:
            self.txn_user_combo.set("No users available")
            self.txn_user_combo.config(state='disabled')

    def refresh_stock_dropdown(self):
        stock_codes = self.controller.get_stocks_dropdown_data()
        stock_codes = stock_codes if stock_codes else []
        self.txn_stock_combo['values'] = stock_codes
        if stock_codes:
            self.txn_stock_combo.set(stock_codes[0])
            self.txn_stock_combo.config(state='readonly')
        else:
            self.txn_stock_combo.set("No stocks available")
            self.txn_stock_combo.config(state='disabled')

# ----- Tab Dividen -----
class DividenTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        # Use ttk widgets
        ttk.Label(self, text="Select Stock:").grid(row=0, column=0, padx=10, pady=5, sticky='w')
        self.div_stock_combo, self.get_div_stock_code = self.create_stock_dropdown(self)
        self.div_stock_combo.grid(row=0, column=1, padx=10, pady=5, sticky='ew')

        ttk.Label(self, text="Select Dividend type:").grid(row=1, column=0, padx=10, pady=5, sticky='w')
        self.div_type_combo, self.get_div_type = self.create_dividen_type_drop_down(self)
        self.div_type_combo.grid(row=1, column=1, padx=10, pady=5, sticky='ew')

        ttk.Label(self, text="Payment date").grid(row=2, column=0, padx=10, pady=5, sticky='w')
        self.payment_date_entry = ttk.Entry(self) # Consider DateEntry
        self.payment_date_entry.grid(row=2, column=1, padx=10, pady=5, sticky='ew')

        self.div_type_combo.bind("<<ComboboxSelected>>", self.update_dividen_fields)
        self.additional_field_label = ttk.Label(self, text="Cash per stock own:") # Use ttk.Label
        self.additional_field_label.grid(row=3, column=0, padx=10, pady=5, sticky='w')
        self.additional_field_entry = ttk.Entry(self) # Use ttk.Entry
        self.additional_field_entry.grid(row=3, column=1, padx=10, pady=5, sticky='ew')

        ttk.Button(self, text="Save Dividend", # Use ttk.Button
                   command=self.save_dividen_action).grid(row=4, column=0, columnspan=2, pady=10)
        self.columnconfigure(1, weight=1) # Allow entry/combo to expand

    def save_dividen_action(self):
        div_type = self.get_div_type()
        div_amount = self.additional_field_entry.get()
        stock_code = self.get_div_stock_code()
        payment_date = self.payment_date_entry.get()

        if not stock_code or stock_code == "No stocks available":
             print("Error: Please select a stock.")
             return
        # Add validation for date and amount
        self.controller.update_stock_for_dividend(stock_code=stock_code, payment_date=payment_date, type=div_type, amount=div_amount)
        # Clear entries
        self.payment_date_entry.delete(0, tk.END)
        self.additional_field_entry.delete(0, tk.END)
        self.div_type_combo.set('Cash')
        if self.div_stock_combo['values']:
            self.div_stock_combo.current(0)
        self.update_dividen_fields(None) # Reset label based on default type
        # Add feedback (optional)

    # Re-use create_stock_dropdown
    def create_stock_dropdown(self, parent):
        stock_codes = self.controller.get_stocks_dropdown_data() # Lấy data từ controller
        stock_codes = stock_codes if stock_codes else []
        stock_combo = ttk.Combobox(parent, values=stock_codes, state='readonly')
        if stock_codes:
            stock_combo.set(stock_codes[0])
        else:
            stock_combo.set("No stocks available")

        def get_selected_stock_code():
            selected_code = stock_combo.get()
            if selected_code == "No stocks available":
                return None
            return selected_code

        return stock_combo, get_selected_stock_code

    def create_dividen_type_drop_down(self, parent):
        dividen_list = ['Cash', 'Stock']
        div_type_combo = ttk.Combobox(parent, values=dividen_list, state='readonly')
        if dividen_list:
            div_type_combo.set(dividen_list[0])

        def get_selected_div_type():
            return div_type_combo.get()

        return div_type_combo, get_selected_div_type

    def update_dividen_fields(self, event): # event can be None if called manually
        selected_type = self.get_div_type()
        if selected_type == 'Cash':
            self.additional_field_label.config(text="Cash per stock own:")
            self.additional_field_entry.grid() # Ensure it's visible
        elif selected_type == 'Stock':
            self.additional_field_label.config(text="Bonus shares ratio (X:100):") # Clarified label
            self.additional_field_entry.grid() # Ensure it's visible
        else: # Should not happen with readonly combobox, but good practice
            self.additional_field_label.config(text="")
            self.additional_field_entry.grid_remove()

    def refresh_stock_dropdown(self):
        stock_codes = self.controller.get_stocks_dropdown_data()
        stock_codes = stock_codes if stock_codes else []
        self.div_stock_combo['values'] = stock_codes
        if stock_codes:
            self.div_stock_combo.set(stock_codes[0])
            self.div_stock_combo.config(state='readonly')
        else:
            self.div_stock_combo.set("No stocks available")
            self.div_stock_combo.config(state='disabled')

# Add refresh methods to PortfolioApp if needed to update dropdowns when users/stocks are added
# Example:
# In PortfolioApp.__init__ after creating tabs:
# self.user_tab.save_callback = self.refresh_user_dropdowns
# self.stock_tab.save_callback = self.refresh_stock_dropdowns

# def refresh_user_dropdowns(self):
#     self.capital_tab.refresh_user_dropdown()
#     self.withdrawal_tab.refresh_user_dropdown()
#     self.transaction_tab.refresh_user_dropdown()

# def refresh_stock_dropdowns(self):
#     self.transaction_tab.refresh_stock_dropdown()
#     self.dividen_tab.refresh_stock_dropdown()

# Then call self.save_callback() within the save_user_action and save_stock_action methods.
# (This requires adding save_callback=None to the __init__ of UserTab and StockTab
# and assigning it: self.save_callback = save_callback)

# --- Main Application Logic (if this file is run directly) ---
# if __name__ == '__main__':
#     # Assuming you have a Controller class defined elsewhere
#     # from controller import Controller
#     # controller = Controller() # Instantiate your controller
#     class MockController: # Placeholder if Controller is not available
#         def save_user(self, name, contact): print(f"Saving user: {name}, {contact}")
#         def save_stock(self, code, name): print(f"Saving stock: {code}, {name}")
#         def save_capital_injection(self, *args): print(f"Saving capital injection: {args}")
#         def save_capital_withdrawal(self, *args): print(f"Saving capital withdrawal: {args}")
#         def save_transaction(self, *args): print(f"Saving transaction: {args}")
#         def update_stock_for_dividend(self, *args, **kwargs): print(f"Saving dividend: {args}, {kwargs}")
#         def get_users_dropdown_data(self): return {"User A": 1, "User B": 2} # Sample data
#         def get_stocks_dropdown_data(self): return ["AAPL", "GOOG", "MSFT"] # Sample data

#     controller = MockController()
#     app = PortfolioApp(controller)
#     app.mainloop()