# Res-Q-Net
ResQNet – a web-based disaster assistance platform with SOS requests, location sharing, nearby helper matching, and emergency guidance. Built with React, Node.js, Express and MongoDB.
## Features

- **SOS requests**: send an emergency request with type, details and live GPS location
- **Nearby helper matching**: finds helpers within a configurable radius; requests stay pending until a helper responds
- **Map-based assistance**: helpers see the affected user's location on a map and the request status updates as they respond
- **Disaster alerts and notifications**: timely, reliable information in a single platform
- **Safety and preparedness guidance**: instructions for different disaster situations
- **Resource locator**: nearby shelters, hospitals, rescue teams and relief resources
- **AI-powered assistance**: structured guidance for emergencies and preparedness
- **Role-based access**: separate roles for affected users, volunteers/helpers and administrators

## How it works

1. User registers or logs in (Affected User or Helper)
2. App captures the device's current location
3. User submits an emergency help request to the backend API
4. Backend searches for helpers within the configured radius
5. Matching requests appear in the helper's request list; otherwise the request stays pending
6. A helper accepts the request, sees the user's details and map location, and the status updates
7. The helper uses the map to reach the affected user

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | React.js, HTML, CSS, JavaScript |
| Backend | Node.js, Express.js |
| Database | MongoDB |
| Maps and location | Geolocation API / mapping APIs |
| Auth and security | Secure login, role-based access, input validation, protected APIs |

## Roadmap

- Push, email and SMS emergency notifications
- Cloud deployment on scalable infrastructure
- Additional map, API and third-party service integrations

## Authors

- Kahan Gandhi
- Priyanka Mohanty

**Guide:** Ms. Vaishvari Desai
B.Tech (CSE), Department of Computer Engineering, Silver Oak University
Minor Project (ID: 10101043494)
