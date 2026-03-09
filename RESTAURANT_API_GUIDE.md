# Restaurant Backend API Guide

This document provides a complete reference for all restaurant-related API endpoints. All endpoints require authentication via Bearer token unless specified otherwise.

---

## Table of Contents

1. [Restaurant Profile Management](#1-restaurant-profile-management)
2. [Restaurant Discovery (Customer)](#2-restaurant-discovery-customer)
3. [Menu Management](#3-menu-management)
4. [Food Order Management](#4-food-order-management)
5. [Advertising System](#5-advertising-system)
6. [WebSocket Real-time Events](#6-websocket-real-time-events)
7. [Error Responses](#7-error-responses)

---

## 1. Restaurant Profile Management

### 1.1 Get Restaurant Profile

**Endpoint:** `GET /api/food/restaurant/profile`

**Authentication:** Required (Restaurant role)

**Description:** Returns the profile of the authenticated restaurant.

**Response:** `200 OK`
```json
{
  "user_id": "rest-123",
  "restaurant_name": "Thai Delight",
  "description": "Authentic Thai cuisine",
  "cuisine_type": "Thai",
  "address": "123 Main St, Bangkok",
  "lat": 13.7563,
  "lng": 100.5018,
  "logo_url": "https://storage.example.com/logos/rest-123.jpg",
  "cover_image_url": "https://storage.example.com/covers/rest-123.jpg",
  "rating": 4.5,
  "is_active": true,
  "is_open": true,
  "min_order_amount": 100.0,
  "is_sponsored": false,
  "bank_code": "SCB",
  "bank_account_number": "encrypted_string",
  "created_at": "2024-01-01T00:00:00Z"
}
```

**Error:** `404 Not Found`
```json
{
  "message": "restaurant profile not found"
}
```

---

### 1.2 Update Restaurant Profile

**Endpoint:** `PUT /api/food/restaurant/profile`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "restaurant_name": "Thai Delight Updated",
  "description": "Updated description",
  "cuisine_type": "Thai Fusion",
  "address": "456 New St, Bangkok",
  "lat": 13.7600,
  "lng": 100.5100,
  "logo_url": "new-logo-key.jpg",
  "cover_image_url": "new-cover-key.jpg",
  "min_order_amount": 150.0,
  "bank_code": "BBL",
  "bank_account_number": "new-account-number"
}
```

**Response:** `200 OK`
```json
{
  "restaurant_name": "Thai Delight Updated",
  "description": "Updated description",
  "cuisine_type": "Thai Fusion",
  "address": "456 New St, Bangkok",
  "lat": 13.76,
  "lng": 100.51,
  "logo_url": "new-logo-key.jpg",
  "cover_image_url": "new-cover-key.jpg",
  "min_order_amount": 150,
  "bank_code": "BBL",
  "bank_account_number": "new-account-number"
}
```

**Error:** `400 Bad Request`
```json
{
  "message": "invalid request body"
}
```

---

### 1.3 Toggle Restaurant Open Status

**Endpoint:** `POST /api/food/restaurant/open`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "is_open": true
}
```

**Response:** `200 OK`
```json
{
  "is_open": true
}
```

**Error:** `400 Bad Request`
```json
{
  "message": "invalid request body"
}
```

---

## 2. Restaurant Discovery (Customer)

### 2.1 Get Nearby Restaurants

**Endpoint:** `GET /api/food/customer/restaurants/nearby?lat={lat}&lng={lng}`

**Authentication:** Required (Customer role)

**Query Parameters:**
- `lat` (required): Latitude coordinate
- `lng` (required): Longitude coordinate

**Example:** `GET /api/food/customer/restaurants/nearby?lat=13.7563&lng=100.5018`

**Response:** `200 OK`
```json
[
  {
    "user_id": "rest-123",
    "restaurant_name": "Thai Delight",
    "description": "Authentic Thai cuisine",
    "cuisine_type": "Thai",
    "address": "123 Main St, Bangkok",
    "lat": 13.7563,
    "lng": 100.5018,
    "logo_url": "https://storage.example.com/logos/rest-123.jpg",
    "cover_image_url": "https://storage.example.com/covers/rest-123.jpg",
    "rating": 4.5,
    "is_active": true,
    "is_open": true,
    "min_order_amount": 100.0,
    "is_sponsored": true,
    "distance_km": 1.2,
    "has_drivers_nearby": true,
    "delivery_fee": 25.0,
    "duration_min": 20,
    "is_estimate": false,
    "bid_per_click": 5.0
  }
]
```

**Notes:**
- Results include both sponsored and organic listings
- Sponsored restaurants appear at positions 1, 5, 9...
- `delivery_fee`, `duration_min`, `distance_km` are calculated based on user location
- `is_estimate: true` means values are estimated (no cached route data)

**Error:** `400 Bad Request`
```json
{
  "message": "invalid lat"
}
```

---

### 2.2 Get Restaurant by ID

**Endpoint:** `GET /api/food/customer/restaurants/{id}`

**Authentication:** Required (Customer role)

**Path Parameters:**
- `id`: Restaurant ID

**Response:** `200 OK`
```json
{
  "user_id": "rest-123",
  "restaurant_name": "Thai Delight",
  "description": "Authentic Thai cuisine",
  "cuisine_type": "Thai",
  "address": "123 Main St, Bangkok",
  "lat": 13.7563,
  "lng": 100.5018,
  "logo_url": "https://storage.example.com/logos/rest-123.jpg",
  "cover_image_url": "https://storage.example.com/covers/rest-123.jpg",
  "rating": 4.5,
  "is_active": true,
  "is_open": true,
  "min_order_amount": 100.0,
  "is_sponsored": false,
  "bank_code": "SCB",
  "bank_account_number": "encrypted_string",
  "created_at": "2024-01-01T00:00:00Z"
}
```

**Error:** `404 Not Found`
```json
{
  "message": "restaurant not found"
}
```

---

### 2.3 Record Ad Click

**Endpoint:** `POST /api/food/customer/restaurants/{id}/click`

**Authentication:** Required (Customer role)

**Description:** Records when a customer clicks on a sponsored restaurant.

**Response:** `200 OK`
```json
{
  "message": "click recorded"
}
```

**Error:** `404 Not Found`
```json
{
  "message": "restaurant or ad not found"
}
```

---

## 3. Menu Management

### 3.1 Create Category

**Endpoint:** `POST /api/food/restaurant/menu/categories`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "name": "Appetizers",
  "sort_order": 1
}
```

**Response:** `201 Created`
```json
{
  "id": "cat-123",
  "restaurant_id": "rest-123",
  "name": "Appetizers",
  "sort_order": 1,
  "is_active": true
}
```

**Error:** `400 Bad Request`
```json
{
  "error": "name is required"
}
```

---

### 3.2 List Categories

**Endpoint:** `GET /api/food/restaurant/menu/categories`

**Authentication:** Required (Restaurant role)

**Response:** `200 OK`
```json
[
  {
    "id": "cat-123",
    "restaurant_id": "rest-123",
    "name": "Appetizers",
    "sort_order": 1,
    "is_active": true
  }
]
```

---

### 3.3 Update Category

**Endpoint:** `PUT /api/food/restaurant/menu/categories/{id}`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "name": "Starters",
  "sort_order": 2,
  "is_active": true
}
```

**Response:** `200 OK`
```json
{
  "message": "category updated successfully"
}
```

---

### 3.4 Delete Category

**Endpoint:** `DELETE /api/food/restaurant/menu/categories/{id}`

**Authentication:** Required (Restaurant role)

**Response:** `204 No Content`

---

### 3.5 Create Menu Item

**Endpoint:** `POST /api/food/restaurant/menu/items`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "category_id": "cat-123",
  "name": "Spring Rolls",
  "description": "Crispy vegetable spring rolls",
  "price": 89.0,
  "image_url": "spring-rolls.jpg",
  "options": "{\"spice_level\": \"mild\"}"
}
```

**Response:** `201 Created`
```json
{
  "id": "item-456",
  "restaurant_id": "rest-123",
  "category_id": "cat-123",
  "name": "Spring Rolls",
  "description": "Crispy vegetable spring rolls",
  "price": 89.0,
  "image_url": "spring-rolls.jpg",
  "is_available": true,
  "options": "{\"spice_level\": \"mild\"}",
  "created_at": "2024-01-01T00:00:00Z"
}
```

**Error:** `400 Bad Request`
```json
{
  "error": "name, category_id, and price > 0 are required"
}
```

---

### 3.6 Update Menu Item

**Endpoint:** `PUT /api/food/restaurant/menu/items/{id}`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "category_id": "cat-123",
  "name": "Spring Rolls (Large)",
  "description": "Large crispy vegetable spring rolls",
  "price": 129.0,
  "image_url": "spring-rolls-large.jpg",
  "is_available": true,
  "options": "{\"spice_level\": \"medium\"}"
}
```

**Response:** `200 OK`
```json
{
  "message": "item updated successfully"
}
```

---

### 3.7 Delete Menu Item

**Endpoint:** `DELETE /api/food/restaurant/menu/items/{id}`

**Authentication:** Required (Restaurant role)

**Response:** `204 No Content`

---

### 3.8 Create Modifier Group

**Endpoint:** `POST /api/food/restaurant/modifier-groups`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "name": "Spiciness Level",
  "min_select": 0,
  "max_select": 1
}
```

**Response:** `201 Created`
```json
{
  "id": "group-789",
  "restaurant_id": "rest-123",
  "name": "Spiciness Level",
  "min_select": 0,
  "max_select": 1,
  "is_active": true,
  "modifiers": []
}
```

**Validation:**
- `name`: required, 1-100 characters
- `min_select`: >= 0
- `max_select`: >= 1

---

### 3.9 Update Modifier Group

**Endpoint:** `PUT /api/food/restaurant/modifier-groups/{id}`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "name": "Spice Level",
  "min_select": 0,
  "max_select": 2,
  "is_active": true
}
```

**Response:** `200 OK`
```json
{
  "message": "modifier group updated"
}
```

---

### 3.10 Delete Modifier Group

**Endpoint:** `DELETE /api/food/restaurant/modifier-groups/{id}`

**Authentication:** Required (Restaurant role)

**Response:** `204 No Content`

---

### 3.11 Link Modifier Group to Item

**Endpoint:** `POST /api/food/restaurant/items/{itemID}/modifier-groups`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "modifier_group_id": "group-789",
  "sort_order": 1
}
```

**Response:** `200 OK`
```json
{
  "message": "modifier group linked to item"
}
```

---

### 3.12 Unlink Modifier Group from Item

**Endpoint:** `DELETE /api/food/restaurant/items/{itemID}/modifier-groups/{gid}`

**Authentication:** Required (Restaurant role)

**Response:** `204 No Content`

---

### 3.13 Create Modifier

**Endpoint:** `POST /api/food/restaurant/modifier-groups/{gid}/modifiers`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "name": "Extra Spicy",
  "price": 0.0
}
```

**Response:** `201 Created`
```json
{
  "id": "mod-111",
  "modifier_group_id": "group-789",
  "name": "Extra Spicy",
  "price": 0.0,
  "is_available": true,
  "sort_order": 1
}
```

**Validation:**
- `name`: required, 1-100 characters
- `price`: >= 0

---

### 3.14 Update Modifier

**Endpoint:** `PUT /api/food/restaurant/modifiers/{id}`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "name": "Very Spicy",
  "price": 5.0,
  "is_available": true,
  "sort_order": 2
}
```

**Response:** `200 OK`
```json
{
  "message": "modifier updated"
}
```

---

### 3.15 Delete Modifier

**Endpoint:** `DELETE /api/food/restaurant/modifiers/{id}`

**Authentication:** Required (Restaurant role)

**Response:** `204 No Content`

---

### 3.16 Get Restaurant Menu (Customer)

**Endpoint:** `GET /api/food/customer/restaurants/{id}/menu`

**Authentication:** Required (Customer role)

**Description:** Returns the full menu of a restaurant, grouped by category.

**Response:** `200 OK`
```json
{
  "categories": [
    {
      "id": "cat-123",
      "restaurant_id": "rest-123",
      "name": "Appetizers",
      "sort_order": 1,
      "is_active": true,
      "items": [
        {
          "id": "item-456",
          "restaurant_id": "rest-123",
          "category_id": "cat-123",
          "name": "Spring Rolls",
          "description": "Crispy vegetable spring rolls",
          "price": 89.0,
          "image_url": "spring-rolls.jpg",
          "is_available": true,
          "options": "{\"spice_level\": \"mild\"}",
          "created_at": "2024-01-01T00:00:00Z"
        }
      ]
    }
  ]
}
```

---

## 4. Food Order Management

### 4.1 Accept Order (Restaurant)

**Endpoint:** `POST /api/food/restaurant/orders/{id}/accept`

**Authentication:** Required (Restaurant role)

**Response:** `200 OK`
```json
{
  "message": "RESTAURANT_ACCEPTED"
}
```

**Order Status Transition:** `PLACED` → `RESTAURANT_ACCEPTED`

**Error:** `400 Bad Request` (if invalid transition)

---

### 4.2 Reject Order (Restaurant)

**Endpoint:** `POST /api/food/restaurant/orders/{id}/reject`

**Authentication:** Required (Restaurant role)

**Response:** `200 OK`
```json
{
  "message": "RESTAURANT_REJECTED"
}
```

**Order Status Transition:** `PLACED` → `RESTAURANT_REJECTED`

---

### 4.3 Mark Order as Preparing

**Endpoint:** `POST /api/food/restaurant/orders/{id}/preparing`

**Authentication:** Required (Restaurant role)

**Response:** `200 OK`
```json
{
  "message": "PREPARING"
}
```

**Order Status Transition:** `RESTAURANT_ACCEPTED` → `PREPARING`

---

### 4.4 Mark Order as Ready for Pickup

**Endpoint:** `POST /api/food/restaurant/orders/{id}/ready`

**Authentication:** Required (Restaurant role)

**Response:** `200 OK`
```json
{
  "message": "READY_FOR_PICKUP"
}
```

**Order Status Transition:** `PREPARING` → `READY_FOR_PICKUP`

---

### 4.5 List Pending Orders

**Endpoint:** `GET /api/food/restaurant/orders/pending?status={status}`

**Authentication:** Required (Restaurant role)

**Query Parameters:**
- `status` (optional): Comma-separated list of statuses to filter (e.g., `PLACED,RESTAURANT_ACCEPTED`)

**Response:** `200 OK`
```json
[
  {
    "id": "order-123",
    "customer_id": "cust-456",
    "restaurant_id": "rest-123",
    "driver_id": null,
    "status": "PLACED",
    "delivery_lat": 13.7563,
    "delivery_lng": 100.5018,
    "delivery_address": "456 Customer St",
    "food_total": 250.0,
    "delivery_fee": 25.0,
    "total_amount": 275.0,
    "payment_method": "credit_card",
    "placed_at": "2024-01-01T12:00:00Z",
    "delivered_at": null,
    "items": [
      {
        "id": "orderitem-1",
        "order_id": "order-123",
        "menu_item_id": "item-456",
        "name": "Spring Rolls",
        "quantity": 2,
        "unit_price": 89.0,
        "variant_options": null,
        "selected_modifiers": [],
        "subtotal": 178.0
      }
    ],
    "tier": "STANDARD",
    "batch_id": null,
    "batch_sequence": null,
    "original_eta_min": 25,
    "batched_eta_min": null,
    "delay_queue_until": null,
    "prep_time_adjustment_min": 0,
    "oos_items": [],
    "original_total_amount": 275.0,
    "promo_discount": 0.0,
    "promo_min_spend": 0.0,
    "batching_enabled": true
  }
]
```

---

### 4.6 Update Order Operations

**Endpoint:** `PUT /api/food/restaurant/orders/{id}/ops`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "prep_time_adjustment_min": 5,
  "oos_order_item_ids": ["orderitem-1"]
}
```

**Fields:**
- `prep_time_adjustment_min`: Additional prep time in minutes (can be negative to reduce)
- `oos_order_item_ids`: Array of order item IDs that are out of stock

**Response:** `200 OK`
```json
{
  "message": "order updated successfully"
}
```

---

### 4.7 Toggle Restaurant Busy Mode

**Endpoint:** `POST /api/food/restaurant/busy`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "is_busy": true,
  "duration_min": 30
}
```

**Fields:**
- `is_busy`: Set restaurant as busy (temporarily stop accepting orders)
- `duration_min`: Optional duration in minutes for busy mode

**Response:** `200 OK`
```json
{
  "message": "busy mode updated"
}
```

**Error:** `400 Bad Request`
```json
{
  "message": "is_busy field is required"
}
```

---

## 5. Advertising System

### 5.1 Create Ad

**Endpoint:** `POST /api/food/restaurant/ads`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "daily_budget": 500.0,
  "bid_per_click": 5.0
}
```

**Validation:**
- `daily_budget`: required, minimum 100 THB
- `bid_per_click`: required, minimum 1 THB

**Response:** `200 OK`
```json
{
  "id": "ad-123",
  "restaurant_id": "rest-123",
  "daily_budget": 500.0,
  "current_spend": 0.0,
  "bid_per_click": 5.0,
  "is_active": true,
  "last_reset_at": "2024-01-01T00:00:00Z",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

**Errors:**
- `400 Bad Request` - daily_budget < 100
```json
{
  "message": "daily budget must be at least 100 THB"
}
```

- `400 Bad Request` - bid_per_click < 1
```json
{
  "message": "bid per click must be at least 1 THB"
}
```

---

### 5.2 Get Ad

**Endpoint:** `GET /api/food/restaurant/ads`

**Authentication:** Required (Restaurant role)

**Response:** `200 OK`
```json
{
  "id": "ad-123",
  "restaurant_id": "rest-123",
  "daily_budget": 500.0,
  "current_spend": 125.0,
  "bid_per_click": 5.0,
  "is_active": true,
  "last_reset_at": "2024-01-01T00:00:00Z",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

**Error:** `404 Not Found`
```json
{
  "message": "ad not found"
}
```

---

### 5.3 Update Ad

**Endpoint:** `PUT /api/food/restaurant/ads`

**Authentication:** Required (Restaurant role)

**Request Body:**
```json
{
  "daily_budget": 1000.0,
  "bid_per_click": 7.5,
  "is_active": true
}
```

**All fields are optional.**

**Validation:**
- `daily_budget`: if provided, minimum 100 THB
- `bid_per_click`: if provided, minimum 1 THB

**Response:** `200 OK`
```json
{
  "message": "ad updated successfully"
}
```

---

## 6. WebSocket Real-time Events

### 6.1 WebSocket Connection

**Endpoint:** `GET /ws`

**Authentication:** Required (Bearer token via query param or header)

**Description:** Real-time bidirectional communication channel for order updates and notifications.

**Connection URL:**
```
ws://api.example.com/ws?token=<your-jwt-token>
```

Or with Authorization header (if supported by your WS client):
```
ws://api.example.com/ws
Authorization: Bearer <your-jwt-token>
```

**Notes:**
- Connection must be established before receiving real-time events
- Server sends ping messages every 54 seconds
- Client should respond with pong within 60 seconds
- Connection timeout: 30 seconds idle

---

### 6.2 Restaurant WebSocket Events

When connected via WebSocket, restaurants receive real-time events for order lifecycle changes.

#### Order Created (New Order)

**Event Type:** `order_created`

**Payload:**
```json
{
  "type": "order_created",
  "order_id": "order-123",
  "status": "PLACED",
  "order": {
    "id": "order-123",
    "customer_id": "cust-456",
    "restaurant_id": "rest-123",
    "driver_id": null,
    "status": "PLACED",
    "delivery_lat": 13.7563,
    "delivery_lng": 100.5018,
    "delivery_address": "456 Customer St, Bangkok",
    "food_total": 250.0,
    "delivery_fee": 25.0,
    "total_amount": 275.0,
    "payment_method": "credit_card",
    "placed_at": "2024-01-01T12:00:00Z",
    "items": [
      {
        "id": "orderitem-1",
        "order_id": "order-123",
        "menu_item_id": "item-456",
        "name": "Spring Rolls",
        "quantity": 2,
        "unit_price": 89.0,
        "variant_options": null,
        "selected_modifiers": [],
        "subtotal": 178.0
      }
    ],
    "tier": "STANDARD",
    "batching_enabled": true
  }
}
```

**When Received:** When a customer places a new order

---

#### Order Accepted

**Event Type:** `order_accepted`

**Payload:**
```json
{
  "type": "order_accepted",
  "order_id": "order-123",
  "status": "RESTAURANT_ACCEPTED"
}
```

**When Received:** When restaurant accepts the order (echo back for confirmation)

---

#### Order Rejected

**Event Type:** `order_rejected`

**Payload:**
```json
{
  "type": "order_rejected",
  "order_id": "order-123",
  "status": "RESTAURANT_REJECTED"
}
```

**When Received:** When restaurant rejects the order

---

#### Order Preparing

**Event Type:** `order_preparing`

**Payload:**
```json
{
  "type": "order_preparing",
  "order_id": "order-123",
  "status": "PREPARING"
}
```

**When Received:** When restaurant marks order as being prepared

---

#### Order Ready for Pickup

**Event Type:** `order_ready`

**Payload:**
```json
{
  "type": "order_ready",
  "order_id": "order-123",
  "status": "READY_FOR_PICKUP"
}
```

**When Received:** When restaurant marks order as ready for driver pickup

---

#### Driver Assigned

**Event Type:** `driver_assigned`

**Payload:**
```json
{
  "type": "driver_assigned",
  "order_id": "order-123",
  "driver_id": "driver-789"
}
```

**When Received:** When a driver is assigned to the order

---

#### Order Picked Up

**Event Type:** `order_picked_up`

**Payload:**
```json
{
  "type": "order_picked_up",
  "order_id": "order-123",
  "status": "DRIVER_PICKED_UP"
}
```

**When Received:** When driver picks up the order from restaurant

---

#### Order Delivered

**Event Type:** `order_delivered`

**Payload:**
```json
{
  "type": "order_delivered",
  "order_id": "order-123",
  "status": "DELIVERED"
}
```

**When Received:** When driver completes the delivery

---

#### Order Cancelled

**Event Type:** `order_cancelled`

**Payload:**
```json
{
  "type": "order_cancelled",
  "order_id": "order-123",
  "status": "CANCELLED",
  "reason": "Customer cancelled before restaurant accepted"
}
```

**When Received:** When order is cancelled by customer or system

---

### 6.3 WebSocket Event Summary Table

| Event Type | Direction | Description |
|------------|-----------|-------------|
| `order_created` | Server → Restaurant | New order placed by customer |
| `order_accepted` | Server → Restaurant | Restaurant accepted order (echo) |
| `order_rejected` | Server → Restaurant | Restaurant rejected order |
| `order_preparing` | Server → Restaurant | Restaurant started preparing |
| `order_ready` | Server → Restaurant | Order ready for pickup |
| `driver_assigned` | Server → Restaurant | Driver assigned to order |
| `order_picked_up` | Server → Restaurant | Driver picked up order |
| `order_delivered` | Server → Restaurant | Order delivered to customer |
| `order_cancelled` | Server → Restaurant | Order cancelled |

---

### 6.4 Example WebSocket Client (JavaScript)

```javascript
const ws = new WebSocket('ws://api.example.com/ws?token=' + jwtToken);

ws.onopen = () => {
  console.log('WebSocket connected');
};

ws.onmessage = (event) => {
  const message = JSON.parse(event.data);
  
  switch (message.type) {
    case 'order_created':
      console.log('New order received:', message.order_id);
      // Show notification to restaurant staff
      break;
    case 'driver_assigned':
      console.log('Driver assigned:', message.driver_id);
      // Update order status in UI
      break;
    case 'order_picked_up':
      console.log('Order picked up by driver');
      break;
    case 'order_delivered':
      console.log('Order delivered');
      break;
    default:
      console.log('Unknown event:', message.type);
  }
};

ws.onerror = (error) => {
  console.error('WebSocket error:', error);
};

ws.onclose = () => {
  console.log('WebSocket disconnected, reconnecting...');
  // Implement reconnection logic
  setTimeout(connectWebSocket, 3000);
};
```

---

## 7. Error Responses

### Standard Error Format

All error responses follow this format:

```json
{
  "message": "error description"
}
```

Or for structured errors:

```json
{
  "code": "ERROR_CODE",
  "message": "Human-readable error message",
  "request_id": "req-123"
}
```

### Common HTTP Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| 200 | OK | Successful operation |
| 201 | Created | Resource created successfully |
| 204 | No Content | Successful deletion |
| 400 | Bad Request | Invalid request body or parameters |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |

### Authentication

All endpoints require a Bearer token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

The token must be obtained via `/auth/login` or `/auth/register` endpoints.

### Rate Limiting

- **General API:** 100 requests per minute per user
- **OTP:** 3 requests per 15 minutes per IP
- **Payout:** 5 requests per day per driver
- **Order Cancellation:** 3 per hour per user
- **Profile Update:** 10 per minute per user

When rate limit is exceeded:

```json
{
  "message": "API rate limit exceeded."
}
```

---

## Appendix: Order Status Flow

```
PLACED
  ├─→ RESTAURANT_ACCEPTED → PREPARING → READY_FOR_PICKUP → DRIVER_ASSIGNED → DRIVER_PICKED_UP → DELIVERED
  ├─→ RESTAURANT_REJECTED
  └─→ CANCELLED
```

**Valid Transitions:**
- `PLACED` → `RESTAURANT_ACCEPTED`, `RESTAURANT_REJECTED`, `CANCELLED`
- `RESTAURANT_ACCEPTED` → `PREPARING`
- `PREPARING` → `READY_FOR_PICKUP`
- `READY_FOR_PICKUP` → `DRIVER_ASSIGNED`, `DRIVER_PICKED_UP`
- `DRIVER_ASSIGNED` → `DRIVER_PICKED_UP`
- `DRIVER_PICKED_UP` → `DELIVERED`

---

## Appendix: Delivery Tiers

| Tier | Display Name | Fee Multiplier | Batching | Description |
|------|-------------|----------------|----------|-------------|
| `SAVER` | ประหยัด / Saver | 0.7x (30% cheaper) | Yes (5 min hold) | Cheaper delivery, may take longer |
| `STANDARD` | ปกติ / Standard | 1.0x (base fee) | Yes (90s hold) | Normal delivery with opportunistic batching |
| `PRIORITY` | ด่วน / Priority | 1.5x (50% premium) | No | Fastest delivery, direct routing |

---

**Document Version:** 1.0  
**Last Updated:** 2025-03-09
