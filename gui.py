import tkinter as tk
from tkinter import ttk
from controller import PortfolioController  # Import Controller
from icecream import ic
class PortfolioApp(tk.Tk):
    def __init__(self, controller):
        super().__init__()
        self.controller = controller # Nhận controller instance
        self.title("Investment Portfolio Management")

        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill='both', expand=True)

        self.overall_tab = OverallPerformanceTab(self.notebook, controller=self.controller)
        self.user_tab = UserTab(self.notebook, controller=self.controller)
        self.stock_tab = StockTab(self.notebook, controller=self.controller)
        self.capital_tab = CapitalInjectionTab(self.notebook, controller=self.controller)
        self.transaction_tab = TransactionTab(self.notebook, controller=self.controller)
        self.dividen_tab = DividenTab(self.notebook, controller=self.controller)

        self.notebook.add(self.overall_tab, text="Overall Performance")
        self.notebook.add(self.user_tab, text="Add new User")
        self.notebook.add(self.stock_tab, text="Add new Stock")
        self.notebook.add(self.capital_tab, text="Capital Injection")
        self.notebook.add(self.transaction_tab, text="Transaction")
        self.notebook.add(self.dividen_tab, text="Dividend")

        self.notebook.select(self.overall_tab) # Tab mặc định

# ----- Tab Overall Performance -----
class OverallPerformanceTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        self.perf_view_frame = ttk.Frame(self)
        self.perf_view_frame.grid(row=0, column=0, columnspan=2, padx=10, pady=10, sticky='nsew')
        self.update_overall_performance()

    def update_overall_performance(self):
        
        # Xóa toàn bộ nội dung cũ trong perf_view_frame
        for widget in self.perf_view_frame.winfo_children():
            widget.destroy()
        
        users_performance = self.controller.get_overall_performance_data() # Lấy data từ controller
        
        # Tiêu đề bảng
        header_frame = ttk.Frame(self.perf_view_frame)
        header_frame.pack(fill='x', padx=5, pady=5)
        tk.Label(header_frame, text="User (ID)", width=20, anchor='w').grid(row=0, column=0)
        tk.Label(header_frame, text="Cash Balance", width=15, anchor='w').grid(row=0, column=1)
        tk.Label(header_frame, text="Total injection", width=15, anchor='w').grid(row=0, column=2)
        tk.Label(header_frame, text="Current Value", width=15, anchor='w').grid(row=0, column=3)
        tk.Label(header_frame, text="Total asset", width=15, anchor='w').grid(row=0, column=4)
        tk.Label(header_frame, text="Profit ($)", width=15, anchor='w').grid(row=0, column=5)
        tk.Label(header_frame, text="Profit (%)", width=15, anchor='w').grid(row=0, column=6)
        tk.Label(header_frame, text="Action", width=12, anchor='w').grid(row=0, column=7)
        
        # Hiển thị dữ liệu user performance
        for user_perf in users_performance:
            row_frame = ttk.Frame(self.perf_view_frame)
            row_frame.pack(fill='x', padx=5, pady=2)
            profit_txt = "N/A"
            if user_perf['total_investment_value'] and user_perf['total_investment_value'] != 0:
                profit_txt = f"{float(user_perf['total_profit_in_percentage']):.2f}%"

            tk.Label(row_frame, text=f"{user_perf['name']} ({user_perf['user_id']})", width=20, anchor='w').grid(row=0, column=0)
            tk.Label(row_frame, text=f"{user_perf['cash_balance']}", width=15, anchor='w').grid(row=0, column=1)
            tk.Label(row_frame, text=f"{user_perf['total_investment_value']}", width=15, anchor='w').grid(row=0, column=2)
            tk.Label(row_frame, text=f"{user_perf['total_current_value']}", width=15, anchor='w').grid(row=0, column=3)
            tk.Label(row_frame, text=f"{user_perf['total_asset_value']}", width=15, anchor='w').grid(row=0, column=4)
            tk.Label(row_frame, text=f"{user_perf['total_profit_in_cash']}", width=15, anchor='w').grid(row=0, column=5)
            tk.Label(row_frame, text=profit_txt, width=15, anchor='w').grid(row=0, column=6)
            tk.Button(row_frame, text="Show Portfolio",
                      command=lambda u_id=user_perf['user_id'], r=row_frame: self.show_portfolio_holdings(u_id, r)).grid(row=0, column=7)
        
    def show_portfolio_holdings(self, user_id, parent_row):
        
        # Xóa portfolio cũ nếu có
        for child in parent_row.winfo_children():
            if getattr(child, 'is_portfolio', False):
                child.destroy()
        
        portfolio_frame = ttk.Frame(parent_row)
        portfolio_frame.is_portfolio = True
        portfolio_frame.grid(row=1, column=0, columnspan=7, sticky='w', padx=20, pady=2)

        portfolio_data = self.controller.get_portfolio_holdings_data(user_id) # Lấy data từ controller

        if not portfolio_data:
            tk.Label(portfolio_frame, text="Không có thông tin portfolio holdings.").pack(anchor='w')
            return
        tk.Label(portfolio_frame, text="PORTFOLIO HOLDINGS").pack(anchor='w')
        # Tiêu đề bảng portfolio
        header = ttk.Frame(portfolio_frame)
        header.pack(fill='x', padx=2, pady=2)
        tk.Label(header, text="Stock Code", width=15, anchor="w").grid(row=0, column=0)
        tk.Label(header, text="Company Name", width=35, anchor="w").grid(row=0, column=1)
        tk.Label(header, text="Current Qty", width=10, anchor="w").grid(row=0, column=2)
        tk.Label(header, text="Avg Cost", width=10, anchor="w").grid(row=0, column=3)
        tk.Label(header, text="Current Price", width=12, anchor="w").grid(row=0, column=4)
        tk.Label(header, text="Profit ($)", width=10, anchor="w").grid(row=0, column=5)
        tk.Label(header, text="Profit (%)", width=10, anchor="w").grid(row=0, column=6)
        # Hiển thị dữ liệu portfolio
        for row in portfolio_data:
            detail_frame = ttk.Frame(portfolio_frame)
            detail_frame.pack(fill='x', padx=2, pady=1)
            tk.Label(detail_frame, text=row['stock_code'], width=15, anchor='w').grid(row=0, column=0)
            tk.Label(detail_frame, text=row['company_name'], width=35, anchor='w').grid(row=0, column=1)
            tk.Label(detail_frame, text=row['current_quantity'], width=10, anchor='w').grid(row=0, column=2)
            tk.Label(detail_frame, text=row['average_cost'], width=10, anchor='w').grid(row=0, column=3)
            tk.Label(detail_frame, text=row['current_price'], width=12, anchor='w').grid(row=0, column=4)
            tk.Label(detail_frame, text=f"{float(row['total_profit_in_cash']):.2f}", width=10, anchor='w').grid(row=0, column=5)
            tk.Label(detail_frame, text=f"{float(row['total_profit_in_percentage']):.2f}%", width=10, anchor='w').grid(row=0, column=6)
        tk.Label(portfolio_frame, text="").pack()  # Space
        

# ----- Tab Add new User -----
class UserTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        tk.Label(self, text="Name:").grid(row=0, column=0, padx=10, pady=10)
        self.user_name_entry = tk.Entry(self)
        self.user_name_entry.grid(row=0, column=1, padx=10, pady=10)
        tk.Label(self, text="Contact Info:").grid(row=1, column=0, padx=10, pady=10)
        self.user_contact_entry = tk.Entry(self)
        self.user_contact_entry.grid(row=1, column=1, padx=10, pady=10)
        tk.Button(self, text="Save User",
                  command=self.save_user_action).grid(row=2, column=0, columnspan=2, pady=10)

    def save_user_action(self):
        name = self.user_name_entry.get()
        contact_info = self.user_contact_entry.get()
        self.controller.save_user(name, contact_info) # Gọi controller method
        # Có thể thêm thông báo thành công/thất bại ở đây

# ----- Tab Add new Stock -----
class StockTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        tk.Label(self, text="Stock Code:").grid(row=0, column=0, padx=10, pady=10)
        self.stock_code_entry = tk.Entry(self)
        self.stock_code_entry.grid(row=0, column=1, padx=10, pady=10)
        tk.Label(self, text="Company Name:").grid(row=1, column=0, padx=10, pady=10)
        self.company_name_entry = tk.Entry(self)
        self.company_name_entry.grid(row=1, column=1, padx=10, pady=10)
        tk.Button(self, text="Save Stock",
                  command=self.save_stock_action).grid(row=2, column=0, columnspan=2, pady=10)

    def save_stock_action(self):
        stock_code = self.stock_code_entry.get()
        company_name = self.company_name_entry.get()
        self.controller.save_stock(stock_code, company_name) # Gọi controller method
        # Có thể thêm thông báo thành công/thất bại ở đây

# ----- Tab Capital Injection -----
class CapitalInjectionTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        tk.Label(self, text="Select User:").grid(row=0, column=0, padx=10, pady=10)
        self.capital_user_combo, self.get_capital_user_id = self.create_user_dropdown(self)
        self.capital_user_combo.grid(row=0, column=1, padx=10, pady=10)
        tk.Label(self, text="Amount:").grid(row=1, column=0, padx=10, pady=10)
        self.capital_amount_entry = tk.Entry(self)
        self.capital_amount_entry.grid(row=1, column=1, padx=10, pady=10)
        tk.Label(self, text="Description:").grid(row=2, column=0, padx=10, pady=10)
        self.capital_desc_entry = tk.Entry(self)
        self.capital_desc_entry.grid(row=2, column=1, padx=10, pady=10)
        tk.Label(self, text="Injection Date:").grid(row=3, column=0, padx=10, pady=10)
        self.capital_date_entry = tk.Entry(self)
        self.capital_date_entry.grid(row=3, column=1, padx=10, pady=10)
        tk.Button(self, text="Save Capital Injection",
                  command=self.save_capital_injection_action).grid(row=4, column=0, columnspan=2, pady=10)

    def save_capital_injection_action(self):
        user_id = self.get_capital_user_id()[1]
        amount = self.capital_amount_entry.get()
        description = self.capital_desc_entry.get()
        injection_date = self.capital_date_entry.get()
        self.controller.save_capital_injection(user_id, amount, description, injection_date) # Gọi controller method
        # Có thể thêm thông báo thành công/thất bại ở đây

    def create_user_dropdown(self, parent):
        users_dict = self.controller.get_users_dropdown_data() # Lấy data từ controller
        user_names = list(users_dict.keys())

        user_combo = ttk.Combobox(parent, values=user_names, state='readonly')
        if user_names:
            user_combo.set(user_names[0])

        def get_selected_user():
            selected_name = user_combo.get()
            return selected_name, users_dict.get(selected_name)

        return user_combo, get_selected_user

# ----- Tab Transaction -----
class TransactionTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        tk.Label(self, text="Select User:").grid(row=0, column=0, padx=10, pady=5)
        self.txn_user_combo, self.get_txn_user = self.create_user_dropdown(self)
        self.txn_user_combo.grid(row=0, column=1, padx=10, pady=5)
        tk.Label(self, text="Select Stock:").grid(row=1, column=0, padx=10, pady=5)
        self.txn_stock_combo, self.get_txn_stock_code = self.create_stock_dropdown(self)
        self.txn_stock_combo.grid(row=1, column=1, padx=10, pady=5)
        tk.Label(self, text="Transaction Date:").grid(row=2, column=0, padx=10, pady=5)
        self.txn_date_entry = tk.Entry(self)
        self.txn_date_entry.grid(row=2, column=1, padx=10, pady=5)
        tk.Label(self, text="Transaction Type:").grid(row=3, column=0, padx=10, pady=5)
        self.txn_type_combo = ttk.Combobox(self, values=['BUY', 'SELL'], state='readonly')
        self.txn_type_combo.set('BUY')
        self.txn_type_combo.grid(row=3, column=1, padx=10, pady=5)
        tk.Label(self, text="Quantity:").grid(row=4, column=0, padx=10, pady=5)
        self.txn_quantity_entry = tk.Entry(self)
        self.txn_quantity_entry.grid(row=4, column=1, padx=10, pady=5)
        tk.Label(self, text="Price:").grid(row=5, column=0, padx=10, pady=5)
        self.txn_price_entry = tk.Entry(self)
        self.txn_price_entry.grid(row=5, column=1, padx=10, pady=5)
        tk.Button(self, text="Save Transaction",
                  command=self.save_transaction_action).grid(row=6, column=0, columnspan=2, pady=10)

    def save_transaction_action(self):
        user_id = self.get_txn_user()[1]
        stock_code = self.get_txn_stock_code()
        transaction_date = self.txn_date_entry.get()
        transaction_type = self.txn_type_combo.get()
        quantity = self.txn_quantity_entry.get()
        price = self.txn_price_entry.get()
        self.controller.save_transaction(user_id, stock_code, transaction_date, transaction_type, quantity, price) # Gọi controller method
        # Có thể thêm thông báo thành công/thất bại ở đây

    def create_user_dropdown(self, parent):
        users_dict = self.controller.get_users_dropdown_data() # Lấy data từ controller
        user_names = list(users_dict.keys())

        user_combo = ttk.Combobox(parent, values=user_names, state='readonly')
        if user_names:
            user_combo.set(user_names[0])

        def get_selected_user():
            selected_name = user_combo.get()
            return selected_name, users_dict.get(selected_name)

        return user_combo, get_selected_user

    def create_stock_dropdown(self, parent):
        stock_codes = self.controller.get_stocks_dropdown_data() # Lấy data từ controller
        stock_combo = ttk.Combobox(parent, values=stock_codes, state='readonly')
        if stock_codes:
            stock_combo.set(stock_codes[0])

        def get_selected_stock_code():
            return stock_combo.get()

        return stock_combo, get_selected_stock_code
    
# ----- Tab Dividen -----
class DividenTab(ttk.Frame):
    def __init__(self, parent, controller):
        super().__init__(parent)
        self.controller = controller
        tk.Label(self, text="Select Stock:").grid(row=0, column=0, padx=10, pady=5)
        self.div_stock_combo, self.get_div_stock_code = self.create_stock_dropdown(self)
        self.div_stock_combo.grid(row=0, column=1, padx=10, pady=5)

        tk.Label(self, text="Select Dividen type:").grid(row=1, column=0, padx=10, pady=5)
        self.div_type_combo, self.get_div_type = self.create_dividen_type_drop_down(self)
        self.div_type_combo.grid(row=1, column=1, padx=10, pady=5)

        tk.Label(self, text="Payment date", padx=10, pady=5).grid(row=2, column=0)
        self.payment_date_entry = tk.Entry(self)
        self.payment_date_entry.grid(row=2, column=1, padx=10, pady=5)

        self.div_type_combo.bind("<<ComboboxSelected>>", self.update_dividen_fields)
        self.additional_field_label = tk.Label(self, text="Cash per stock own:")
        self.additional_field_label.grid(row=3, column=0, padx=10, pady=5)
        self.additional_field_entry = tk.Entry(self)
        self.additional_field_entry.grid(row=3, column=1, padx=10, pady=5)

        tk.Button(self, text="Save Dividen",
                  command=self.save_dividen_action).grid(row=4, column=0, columnspan=2, pady=10)

    def save_dividen_action(self):
        div_type = self.get_div_type()
        div_amount = self.additional_field_entry.get()
        stock_code = self.get_div_stock_code()
        payment_date = self.payment_date_entry.get()
        self.controller.update_stock_for_dividend(stock_code=stock_code, payment_date=payment_date, type=div_type, amount=div_amount)

    def create_stock_dropdown(self, parent):
        stock_codes = self.controller.get_stocks_dropdown_data() # Lấy data từ controller
        stock_combo = ttk.Combobox(parent, values=stock_codes, state='readonly')
        if stock_codes:
            stock_combo.set(stock_codes[0])

        def get_selected_stock_code():
            return stock_combo.get()

        return stock_combo, get_selected_stock_code

    def create_dividen_type_drop_down(self, parent):
        dividen_list = ['Cash', 'Stock']
        div_type_combo = ttk.Combobox(parent, values=dividen_list, state='readonly')
        if dividen_list:
            div_type_combo.set(dividen_list[0])
        
        def get_selected_div_type():
            return div_type_combo.get()
        
        return div_type_combo, get_selected_div_type
    
    def update_dividen_fields(self, event):
        selected_type = self.get_div_type()
        if selected_type == 'Cash':
            self.additional_field_label.config(text="Cash per stock own:")
            self.additional_field_entry.grid()
        elif selected_type == 'Stock':
            self.additional_field_label.config(text="Bonus shares at a ratio of X:100")
            self.additional_field_entry.grid()
        else:
            self.additional_field_label.config(text="")
            self.additional_field_entry.grid_remove()
