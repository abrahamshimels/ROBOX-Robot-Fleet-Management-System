#!/usr/bin/env bash

set -euo pipefail

# ROBOX backend API requests
# Actual backend base URL in this project is http://localhost:4000
# Protected routes use x-api-key authentication, not Bearer auth

BASE_URL="${BASE_URL:-http://localhost:4000}"
API_KEY="${API_KEY:-robox-secret-key}"
ROBOT_ID="${ROBOT_ID:-R002}"

# Common headers
JSON_HEADER="Content-Type: application/json"
API_KEY_HEADER="x-api-key: ${API_KEY}"

###############################################################################
# System
###############################################################################

# Check backend health and robot count
curl --silent --show-error --location \
  "${BASE_URL}/health"

# Open Swagger UI in the browser or fetch the HTML from the terminal
curl --silent --show-error --location \
  "${BASE_URL}/api-docs"

###############################################################################
# Robots
###############################################################################

# List all robots
curl --silent --show-error --location \
  --header "${API_KEY_HEADER}" \
  "${BASE_URL}/robots"

# List robots filtered by status
curl --silent --show-error --location \
  --header "${API_KEY_HEADER}" \
  "${BASE_URL}/robots?status=active"

# List robots filtered by location text
curl --silent --show-error --location \
  --header "${API_KEY_HEADER}" \
  "${BASE_URL}/robots?location=5.1423"

# Search robots across available fields
curl --silent --show-error --location \
  --header "${API_KEY_HEADER}" \
  "${BASE_URL}/robots?search=6G"

# List robots with pagination
curl --silent --show-error --location \
  --header "${API_KEY_HEADER}" \
  "${BASE_URL}/robots?page=1&limit=10"

# Combine filters, search, and pagination in one request
curl --silent --show-error --location \
  --header "${API_KEY_HEADER}" \
  "${BASE_URL}/robots?status=idle&location=2.3&search=Wi-Fi&page=1&limit=5"

# Get one robot by ID
curl --silent --show-error --location \
  --header "${API_KEY_HEADER}" \
  "${BASE_URL}/robots/${ROBOT_ID}"

# Create a new robot with realistic fleet data
curl --silent --show-error --location \
  --request POST \
  --header "${JSON_HEADER}" \
  --header "${API_KEY_HEADER}" \
  --data '{
    "name": "Robot R1001",
    "status": "active",
    "battery": 87,
    "location": "(4.5123, 7.1842, 2.6631)",
    "model": "6G",
    "lastMaintenance": "2026-04-20 09:30:00",
    "task_type": "Inventory Scan",
    "task_duration": 118.4,
    "energy_consumption": 6.8,
    "position_coordinates": "(4.5123, 7.1842, 2.6631)",
    "robot_speed": 0.58,
    "sensor_id": "S12",
    "sensor_type": "Lidar",
    "sensor_reading": 73.2,
    "timestamp": "2026-04-26 08:15:00",
    "data_size": 712,
    "network_load": 66.5,
    "network_latency": 18.1,
    "packet_loss_rate": 1.2,
    "network_type": "6G",
    "slice_id": "Slice2",
    "slice_bandwidth": 1480,
    "command_delay": 7.4,
    "feedback_delay": 11.9,
    "data_transfer_time": 20.6,
    "total_delay": 39.9,
    "signal_strength": -41.7,
    "latency": 6.9,
    "resource_allocation": 84.3,
    "error_rate": 0.08
  }' \
  "${BASE_URL}/robots"

# Update an existing robot
curl --silent --show-error --location \
  --request PUT \
  --header "${JSON_HEADER}" \
  --header "${API_KEY_HEADER}" \
  --data '{
    "name": "Robot R002",
    "status": "idle",
    "battery": 91,
    "location": "(2.1044, 5.8821, 6.1403)",
    "model": "6G",
    "lastMaintenance": "2026-04-25 14:10:00",
    "task_type": "Docking",
    "task_duration": 42.5,
    "energy_consumption": 3.1,
    "position_coordinates": "(2.1044, 5.8821, 6.1403)",
    "robot_speed": 0.21,
    "sensor_id": "S3",
    "sensor_type": "Motion",
    "sensor_reading": 68.4,
    "timestamp": "2026-04-26 08:45:00",
    "data_size": 640,
    "network_load": 49.8,
    "network_latency": 16.3,
    "packet_loss_rate": 0.6,
    "network_type": "6G",
    "slice_id": "Slice1",
    "slice_bandwidth": 1364,
    "command_delay": 6.2,
    "feedback_delay": 9.7,
    "data_transfer_time": 17.4,
    "total_delay": 33.3,
    "signal_strength": -43.2,
    "latency": 6.4,
    "resource_allocation": 88.6,
    "error_rate": 0.03
  }' \
  "${BASE_URL}/robots/${ROBOT_ID}"

# Delete a robot by ID
curl --silent --show-error --location \
  --request DELETE \
  --header "${API_KEY_HEADER}" \
  "${BASE_URL}/robots/${ROBOT_ID}"
