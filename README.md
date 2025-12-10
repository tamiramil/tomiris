# Dreamteam database assistant

## Prerequisites

Install the following dependencies please:
- [Python 3.x](https://www.python.org/downloads/)
- [MySQL database server](https://www.mysql.com/downloads/)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/tamiramil/tomiris.git
cd tomiris
```

### 2. Create a Virtual Environment

```bash
python -m venv venv
```

Activate the virtual environment:

- **Windows:**
  ```bash
  venv\Scripts\activate
  ```

- **macOS/Linux:**
  ```bash
  source venv/bin/activate
  ```

### 3. Install Dependencies

```bash
pip install Faker mysql-connector-python langchain langchain-google-genai sqlalchemy pymysql python-dotenv langchain_community langchain_classic
```

## Setup

### 4. Populate the Database

Run the database population script:

```bash
python populate_db.py
```

You will be prompted to enter:
- MySQL username
- MySQL password
- Database name

### 5. Configure Environment Variables

Create a `.env` file in the project root directory with the following content:

```env
GOOGLE_API_KEY="YOUR_GOOGLE_API_KEY_HERE"
CONNECTION_STRING="mysql+pymysql://username:password@localhost:3306/database_name"
```

**Important:** Replace the placeholders with your actual values:
- `YOUR_GOOGLE_API_KEY_HERE` - Your Google Gemini API key
- `username` - Your MySQL username
- `password` - Your MySQL password
- `database_name` - Your MySQL database name

## Usage

### 6. Run the Application

Open `main.ipynb` in Jupyter Notebook or JupyterLab:

```bash
jupyter notebook main.ipynb
```

Or use any other notebook interface (VS Code, Google Colab, etc.)

### 7. Query the Database

Run the cells in the notebook. To ask different questions:

1. Locate the cell with the `question` variable:
   ```python
   question = \
   """
   Describe the DB please
   """
   ```

2. Change the question to whatever you want to ask about your database:
   ```python
   question = \
   """
   What are the top 5 most expensive pizzas
   """
   ```

3. Run the cell again to get a new answer

## Example Questions

- "How many records are in the database?"
- "What are all the pizza names?"
- "Show me the ingredients for each pizza"
- "What is the total revenue from all orders?"
- "Which pizzas have more than 5 ingredients?"

## Troubleshooting

- **API Key Error:** Ensure your Google Gemini API key is valid and properly set in the `.env` file
- **Database Connection Error:** Verify your MySQL credentials and that the MySQL server is running
- **Import Errors:** Make sure all dependencies are installed in your active virtual environment

## Contacts

- Telegram: @emilbektemir

## Authors

- Temirlan Emilbekov
- Timut Zhumataev
- Elmar Uzakov