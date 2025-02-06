import datetime
import pandas as pd
import vnstock3
import portfolio_management.model.Stock as Stock

def get_stock_price(symbol, start, end=str(datetime.date.today())):
    """Trả về giá cổ phiếu của symbol theo ngày"""
    try:
        df = vnstock3.Vnstock(source="VCI", show_log=False).stock(symbol=symbol, source='VCI').quote.history(start=start, end=end)
        return df
    except Exception as e:
        print(f"Error processing {symbol}: {e}")
        return pd.DataFrame()

def prepare_data():
    pass

def plot():
    pass

