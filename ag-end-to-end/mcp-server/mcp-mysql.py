# mcp-mysql.py
import os, sys, logging
from pathlib import Path
from fastmcp import FastMCP
from typing import List, Dict, Any
import mysql.connector
from agent_guard_core.credentials import (
    ConjurSecretsProvider,
    EnvironmentVariablesManager,
)

# Setup logging to new/overwritten logfile with loglevel
logfile = f"./mcp-mysql.log"
logfmode = "a"  # w = overwrite, a = append
# Log levels: NOTSET DEBUG INFO WARN ERROR CRITICAL
loglevel = logging.INFO
# Cuidado! DEBUG will leak secrets!
logging.basicConfig(
    filename=logfile, encoding="utf-8", level=loglevel, filemode=logfmode
)

class DatabaseConnector:
    def __init__(self):
        namespace_id = os.getenv("NAMESPACE_ID") 
        with EnvironmentVariablesManager(
            ConjurSecretsProvider(namespace=namespace_id)
        ):  # type: ignore
            self.config = {
                "database": os.getenv("MYSQL_DBNAME"),
                "user": os.getenv("MYSQL_USERNAME"),
                "password": os.getenv("MYSQL_PASSWORD"),
                "host": os.getenv("MYSQL_SERVER_ADDRESS"),
                "port": os.getenv("MYSQL_SERVER_PORT"),
            }
        self.connect()

    def connect(self):
        print(
            f"Connecting as user {self.config['user']} to db server at {self.config['host']}"
        )
        logging.info(
            f"Connecting as user {self.config['user']} to db server at {self.config['host']}"
        )
        logging.debug(
            f"Database: {self.config['database']}, Password: {self.config['password']}, Port: {self.config['port']}"
        )
        try:
            self.connection = mysql.connector.connect(
                host=self.config["host"],
                user=self.config["user"],
                password=self.config["password"],
                database=self.config["database"],
                port=self.config["port"],
            )
            self.cursor = self.connection.cursor()
        except Exception as e:
            print(f"Error connecting to the database: {e}")
            logging.error(f"Error connecting to the database: {e}")
            sys.exit(-1)

    def execute_query(self, query: str) -> List[Dict[str, Any]]:
        self.connect()
        self.cursor.execute(query)
        columns = [desc[0] for desc in self.cursor.description]
        results = []
        for row in self.cursor.fetchall():
            results.append({columns[i]: row[i] for i in range(len(columns))})
            logging.debug(f"Query result row: {row}")
        self.connection.close()
        return results


mcp = FastMCP("DatabaseTools")
MYSQL_connector = DatabaseConnector()

@mcp.tool()
def run_sql_query(query: str) -> List[Dict[str, Any]]:
    """Execute a SQL query on the database and return results"""
    try:
        print(f"Executing query: {query}")
        return MYSQL_connector.execute_query(query)
    except Exception as e:
        print(f"Error executing query: {e}")
        return {"error": str(e)} # type: ignore


if __name__ == "__main__":
    mysql_port = int(os.getenv("MCP_HTTP_PORT")) # type: ignore
    mcp.run(transport="http", port=mysql_port)
