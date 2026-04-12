// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },

  modules: ['@nuxtjs/supabase', '@vueuse/nuxt'],

  supabase: {
    url: 'https://scwalytrntqyykujmvvo.supabase.co',
    key: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjd2FseXRybnRxeXlrdWptdnZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU5NDg4NDAsImV4cCI6MjA5MTUyNDg0MH0.WSsnR3kGLTGarTcBnC7Z4pos0M16ahe5asfLrysskPI',
    redirectOptions: {
      login: '/login',
      callback: '/confirm',
      exclude: ['/'],
    },
  },

  css: ['@/assets/css/main.css'],

  app: {
    head: {
      title: 'Floss Jobs – AI Powered Job Matching',
      meta: [
        { name: 'description', content: 'The premium job matching platform for the modern developer.' },
        { name: 'theme-color', content: '#0f172a' }
      ],
      link: [
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap' },
      ],
    },
  },

  runtimeConfig: {
    public: {
      supabaseUrl: 'https://scwalytrntqyykujmvvo.supabase.co',
      supabaseKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjd2FseXRybnRxeXlrdWptdnZvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU5NDg4NDAsImV4cCI6MjA5MTUyNDg0MH0.WSsnR3kGLTGarTcBnC7Z4pos0M16ahe5asfLrysskPI',
    }
  },
})
