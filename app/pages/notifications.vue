<template>
  <div class="notifications-page">
    <main class="container page-content">
      <div class="notifications-list card animate-fade" style="animation-delay: 0.2s;">
        <div v-for="notif in mockNotifications" :key="notif.id" class="notif-item">
          <div class="notif-icon-box" :class="notif.type">
            <component :is="notif.icon" :size="20" />
          </div>
          <div class="notif-text">
            <h4>{{ notif.title }}</h4>
            <p>{{ notif.message }}</p>
            <span class="notif-time">{{ notif.time }}</span>
          </div>
          <div v-if="!notif.read" class="unread-dot"></div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { Bell, Sparkles, CheckCircle } from 'lucide-vue-next';

const mockNotifications = [
  { id: 1, title: 'New Perfect Match!', message: 'A Senior Frontend Role at TechFlow just opened up. It fits your formula perfectly.', time: '2h ago', icon: Sparkles, type: 'success', read: false },
  { id: 2, title: 'Profile Calibrated', message: 'Your career strategy has been updated successfully.', time: '5h ago', icon: CheckCircle, type: 'info', read: true },
  { id: 3, title: 'Welcome to FlossJobs', message: 'Start by filling in your job preferences for AI matching.', time: '1d ago', icon: Bell, type: 'info', read: true },
];
</script>

<style scoped>
.page-content { padding: 2rem 0; }
.notifications-list { padding: 0.5rem; }
.notif-item { display: flex; align-items: flex-start; gap: 1rem; padding: 1.25rem; border-bottom: 1px solid var(--color-border); position: relative; }
.notif-item:last-child { border-bottom: none; }
.notif-icon-box { background: #f1f3f5; padding: 0.6rem; border-radius: 10px; }
.notif-icon-box.success { background: var(--color-primary-light); color: var(--color-primary); }
.notif-icon-box.info { background: #eff6ff; color: #3b82f6; }
.notif-text h4 { margin-bottom: 0.15rem; font-size: 1rem; }
.notif-text p { color: var(--color-text-secondary); margin-bottom: 0.35rem; font-size: 0.9rem; }
.notif-time { font-size: 0.75rem; color: var(--color-text-muted); font-weight: 500; }
.unread-dot { width: 8px; height: 8px; background: var(--color-primary); border-radius: 50%; position: absolute; right: 1.25rem; top: 1.25rem; }
</style>
