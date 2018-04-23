import axios from 'axios';

const baseUrl = 'https://pure-river-10967.herokuapp.com';

export const axiosClient = axios.create({
  baseURL: process.env.NODE_ENV == 'development' ? '' : baseUrl,
  timeout: 1000
});

export const ajaxBaseUrl = process.env.NODE_ENV == 'development' ? '' : baseUrl;
