# Multi-Vehicle Storage Search API

A take-home challenge to build an API that helps renters find storage locations for multiple vehicles.

## Overview

This project implements a search algorithm that allows renters to find storage locations capable of storing multiple vehicles. The API accepts vehicle dimensions and quantities, searches through available listings, and returns the most cost-effective storage solutions.

## API Endpoint

### Request

```bash
POST /api/search
Content-Type: application/json

[
    {
        "length": 10,  # Length in feet
        "quantity": 1  # Number of vehicles with these dimensions
    },
    {
        "length": 20,
        "quantity": 2
    }
]
```

- Each vehicle has a fixed width of 10 feet
- Maximum total quantity of vehicles is 5
- Length values are in feet

### Response

```json
[
    {
        "location_id": "abc123",
        "listing_ids": ["def456", "ghi789"],
        "total_price_in_cents": 300
    }
]
```

The response includes:
- All possible locations that can store the requested vehicles
- Cheapest combination of listings per location
- One result per location_id
- Results sorted by total price (ascending)

## Key Requirements

1. **Input Processing**
   - Accept vehicle dimensions and quantities
   - Validate input constraints (max 5 vehicles total)

2. **Storage Space Search**
   - Search through available listings
   - Each listing contains:
     - ID
     - Length and width (multiples of 10)
     - Location ID
     - Price in cents

3. **Optimization**
   - Find all possible storage solutions
   - Calculate cheapest combination per location
   - Sort results by total price

## Assumptions

1. Vehicles are stored in the same orientation within each listing
2. No buffer space needed between vehicles

## Performance Requirements

- Response time should be under 300ms
- Cold serverless startup time is acceptable

## Technical Notes

This problem is a variant of the [bin packing problem](https://en.wikipedia.org/wiki/Bin_packing_problem).

## Time Investment

Recommended time investment: 6 hours or less
