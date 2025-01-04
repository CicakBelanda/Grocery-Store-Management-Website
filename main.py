from flask import Flask, render_template, request, redirect
from flask_mysqldb import MySQL

app = Flask(__name__)

# Konfigurasi MySQL
app.config['MYSQL_HOST'] = 'localhost'  # Ganti dengan host MySQL Anda
app.config['MYSQL_USER'] = 'root'       # Ganti dengan username MySQL Anda
app.config['MYSQL_PASSWORD'] = ''       # Ganti dengan password MySQL Anda
app.config['MYSQL_DB'] = 'grocerystore'  # Ganti dengan nama database Anda

# Inisialisasi Flask-MySQL
mysql = MySQL(app)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/productdetails')
def product_details():
    try:
        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM productdetailsview')  # Adjust the query as needed
        products = cursor.fetchall()
        cursor.close()
        return render_template('views/productdetails.html', products=products)
    except Exception as e:
        return f"Error: {str(e)}"

@app.route('/employeedetails')
def employee_details():
    try:
        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM employeedetailsview')  # Adjust the query as needed
        employees = cursor.fetchall()
        cursor.close()
        return render_template('views/employeedetails.html', employees=employees)
    except Exception as e:
        return f"Error: {str(e)}"
    
@app.route('/warehousestock')
def warehouse_stock():
    try:
        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM warehousestockview')  # Adjust the query as needed
        warehouses = cursor.fetchall()
        cursor.close()
        return render_template('views/warehousestock.html', warehouses=warehouses)
    except Exception as e:
        return f"Error: {str(e)}"

@app.route('/transactionsummary')
def transaction_summary():
    try:
        cursor = mysql.connection.cursor()
        cursor.execute('SELECT * FROM transactionsummaryview')  # Adjust the query as needed
        transactions = cursor.fetchall()
        cursor.close()
        return render_template('views/transactionsummary.html', transactions=transactions)
    except Exception as e:
        return f"Error: {str(e)}"
    
@app.route('/addproduct', methods=['GET', 'POST'])
def add_product():
    if request.method == 'POST':
        # Get form data
        product_name = request.form['productName']
        category = request.form['category']
        price = request.form['price']
        stock = request.form['stock']
        warehouse = request.form['warehouse']

        try:
            cursor = mysql.connection.cursor()

            # Query to get the last productID
            cursor.execute('SELECT productID FROM product ORDER BY productID DESC LIMIT 1')
            last_product_id = cursor.fetchone()

            if last_product_id:
                # Extract the numeric part of the last productID
                last_id_number = int(last_product_id[0][2:])  # Remove 'PR' and convert to integer
                new_id_number = last_id_number + 1
            else:
                # If no products exist, start with PR001
                new_id_number = 1

            # Format the new productID as PRxxx
            new_product_id = f"PR{new_id_number:03d}"

            # Insert the new product into the database
            cursor.execute('CALL AddNewProduct(%s, %s, %s, %s, %s, %s)', 
                           (new_product_id, product_name, category, price, stock, warehouse))
            mysql.connection.commit()
            cursor.close()
            return redirect('/')  # Redirect to home after successful addition
        except Exception as e:
            return f"Error: {str(e)}"
    
    else:
        try:
            cursor = mysql.connection.cursor()
            # Fetch categories
            cursor.execute('SELECT CategoryID, CategoryName FROM category')  # Adjust the query as needed
            categories = cursor.fetchall()
            # Fetch warehouses
            cursor.execute('SELECT WarehouseID, WarehouseName FROM warehouse')  # Adjust the query as needed
            warehouses = cursor.fetchall()
            cursor.close()
            return render_template('procedures/addproduct.html', categories=categories, warehouses=warehouses)
        except Exception as e:
            return f"Error: {str(e)}"
        
@app.route('/addemployee', methods=['GET', 'POST'])
def add_employee():
    if request.method == 'POST':
        # Get form data
        employee_name = request.form['employeeName']
        address = request.form['employeeAddress']
        age = request.form['employeeAge']
        phone = request.form['employeePhone']
        email = request.form['employeeEmail']
        gender = request.form['employeeGender']
        position = request.form['position']
        dob = request.form['employeeDOB']
        city = request.form['employeeCity']

        try:
            cursor = mysql.connection.cursor()

            # Query to get the last employeeID
            cursor.execute('SELECT EmployeeID FROM employee ORDER BY EmployeeID DESC LIMIT 1')
            last_employee_id = cursor.fetchone()

            if last_employee_id:
                # Extract the numeric part of the last employeeID
                last_id_number = int(last_employee_id[0][2:])  # Remove 'EM' and convert to integer
                new_id_number = last_id_number + 1
            else:
                # If no employees exist, start with PR001
                new_id_number = 1

            # Format the new employeeID as PRxxx
            new_employee_id = f"EM{new_id_number:03d}"

            # Insert the new employee into the database
            cursor.execute('CALL AddEmployee(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', 
                           (new_employee_id, employee_name, address, age, phone, email, gender, position, dob, city))
            mysql.connection.commit()
            cursor.close()
            return redirect('/')  # Redirect to home after successful addition
        except Exception as e:
            return f"Error: {str(e)}"
    
    else:
        try:
            cursor = mysql.connection.cursor()
            # Fetch position
            cursor.execute('SELECT PositionID, PositionName FROM pos')  # Adjust the query as needed
            positions = cursor.fetchall()
            cursor.close()
            return render_template('procedures/addemployee.html', positions=positions)
        except Exception as e:
            return f"Error: {str(e)}"

@app.route('/updatestock', methods=['GET', 'POST'])
def update_stock():
    if request.method == 'POST':
        # Get form data
        product_name = request.form['product']
        stock = request.form['newStock']

        try:
            cursor = mysql.connection.cursor()
            cursor.execute('CALL UpdateStock(%s, %s)', 
                           (product_name, stock))
            mysql.connection.commit()
            cursor.close()
            return redirect('/')  # Redirect to home after successful addition
        except Exception as e:
            return f"Error: {str(e)}"
    
    else:
        try:
            cursor = mysql.connection.cursor()
            # Fetch position
            cursor.execute('SELECT ProductID, ProductName FROM product')  # Adjust the query as needed
            products = cursor.fetchall()
            cursor.close()
            return render_template('procedures/updatestock.html', products=products)
        except Exception as e:
            return f"Error: {str(e)}"

if __name__ == '__main__':
    app.run(debug=True)
