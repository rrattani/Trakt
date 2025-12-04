import { createApp } from 'vue'
import { createHead } from "@vueuse/head"
import Vue3Toastify, { toast } from 'vue3-toastify'
import './style.css'
import App from './App.vue'
import 'flowbite'
import 'vue3-toastify/dist/index.css'

const app = createApp(App)
const head = createHead()

// Configure vue3-toastify
// Only set what you need
app.use(Vue3Toastify, {
  autoClose: 3000, // Auto close after 3 seconds
  position: 'top-right', // Position on screen
  // All other styles will use defaults
})
// Provide toast to all components
app.provide('toast', toast)

app.use(head)

app.mount('#app')
