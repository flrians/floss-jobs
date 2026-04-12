<template>
  <div class="favourites-page">
    <main class="container page-content">
      <div class="favourites-content card animate-fade">
        <div class="empty-state">
          <Heart :size="48" style="color: #ff7675; margin-bottom: 2rem;" />
          <h2>Your Favourites</h2>
          <p>You haven't saved any jobs yet. Browse our matches and click the bookmark icon to save roles here.</p>
          <NuxtLink to="/jobs" class="btn btn-primary" style="margin-top: 2rem;">Browse Matches</NuxtLink>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { Heart } from 'lucide-vue-next';
</script>

<style scoped>
.favourites-content { padding: 5rem; text-align: center; }
.empty-state { max-width: 400px; margin: 0 auto; }
</style>
