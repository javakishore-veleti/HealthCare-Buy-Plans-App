export interface RegisterRequest {
  email: string;
  mobile: string;
  password: string;
  full_name: string;
}

export interface RegisterResponse {
  id: number;
  email: string;
  message: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  access_token: string;
  refresh_token: string;
  expires_in: number;
}

export interface LogoutResponse {
  message: string;
}

export interface ProfileUpdateRequest {
  full_name?: string;
  date_of_birth?: string;
  gender?: string;
  address_line1?: string;
  address_line2?: string;
  city?: string;
  state?: string;
  pincode?: string;
}

export interface ApiError {
  error: string;
  details?: { [key: string]: string[] };
}
