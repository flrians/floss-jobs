<template>
  <div class="app-layout">
    <AppNavbar v-if="user" />
    <NuxtPage />
  </div>
</template>

<script setup>
const user = useSupabaseUser();
</script>

<style>
.app-layout {
  min-height: 100vh;
  font-family: 'Inter', sans-serif;
  background-color: #f8faf9;
}

h1, h2, h3, h4, .logo {
  font-family: 'Outfit', sans-serif;
}

/* Page Transitions */
.page-enter-active,
.page-leave-active {
  transition: all 0.3s ease;
}
.page-enter-from,
.page-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>
