from gui import PortfolioApp
from controller import PortfolioController
from utils.database import connect_db
import time
from utils.stock_price import update_stock_prices

if __name__ == "__main__":
    time.sleep(5)
    controller = PortfolioController(mydb=connect_db()) # Khởi tạo Controller
    app = PortfolioApp(controller) # Truyền controller vào GUI
    app.mainloop()
    controller.db.close() # Đóng kết nối CSDL khi thoát chương trình