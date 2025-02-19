#!/bin/bash

# Create a shortcut for running sql queries
alias sqlq='sqlcmd -S localhost -U sa -P P@ssw0rd -d Northwind -Q'

# Save the alias permanantly in my environment 
echo "alias sqlq='sqlcmd -S localhost -U sa -P P@ssw0rd -d Northwind -Q'" >> ~/.bashrc