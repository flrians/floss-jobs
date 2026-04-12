<template>
  <nav class="navbar animate-slide-down">
    <div class="container nav-container">
      <div class="nav-left">
        <NuxtLink to="/jobs" class="logo no-underline">
          <span>FlossJobs</span>
        </NuxtLink>
      </div>

      <div class="nav-center">
        <div class="nav-menu">
          <NuxtLink to="/jobs" class="nav-link" active-class="active">
            <span>Jobs</span>
          </NuxtLink>
          <NuxtLink to="/cv" class="nav-link" active-class="active">
            <span>CV</span>
          </NuxtLink>
        </div>
      </div>

      <div class="nav-right">
        <div class="nav-actions">
          <NuxtLink to="/notifications" class="nav-icon-btn badge-container" title="Notifications">
            <Bell :size="20" />
            <span class="notification-badge">3</span>
          </NuxtLink>
          
          <NuxtLink to="/profile" class="avatar-link" active-class="active">
            <div class="avatar-small">
              <img :src="profile?.avatar_url || '/avatar.png'" alt="Me" />
            </div>
          </NuxtLink>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { 
  Briefcase, 
  LayoutGrid, 
  FileText, 
  Bell, 
  ChevronDown, 
  LogOut,
  User
} from 'lucide-vue-next';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const router = useRouter();
const profile = ref(null);

onMounted(async () => {
  if (user.value) {
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', user.value.id)
      .single();
    profile.value = data;
  }
});

const handleLogout = async () => {
  await supabase.auth.signOut();
  router.push('/login');
};
</script>

<style scoped>
.navbar {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid var(--color-border);
  height: 72px;
  display: flex;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 1000;
}

.nav-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-left {
  flex: 1;
}

.nav-center {
  flex: 1;
  display: flex;
  justify-content: center;
}

.nav-right {
  flex: 1;
  display: flex;
  justify-content: flex-end;
}

.nav-menu {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.nav-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--color-text-secondary);
  font-weight: 600;
  font-size: 0.95rem;
  padding: 0.5rem 1rem;
  border-radius: 50px;
  transition: all 0.2s ease;
  text-decoration: none !important;
}

.avatar-link {
  display: block;
  padding: 2px;
  border-radius: 50%;
  border: 1px solid transparent;
  transition: all 0.2s ease;
}

.avatar-link:hover, .avatar-link.active {
  border-color: var(--color-primary);
  background: white;
}

.nav-link:hover, .nav-link.active {
  color: var(--color-primary);
  background: var(--color-primary-light);
}

.nav-actions {
  display: flex;
  align-items: center;
  gap: 1.25rem;
}

.nav-icon-btn {
  background: none;
  border: none;
  color: var(--color-text-secondary);
  cursor: pointer;
  padding: 0.5rem;
  border-radius: 50%;
  transition: all 0.2s ease;
  position: relative;
}

.nav-icon-btn:hover {
  background: #f1f3f5;
  color: var(--color-text);
}

.badge-container {
  position: relative;
}

.notification-badge {
  position: absolute;
  top: 6px;
  right: 6px;
  background: #ff4757;
  color: white;
  font-size: 9px;
  font-weight: 800;
  min-width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 10px;
  border: 1.5px solid white;
}

.user-profile-btn {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.4rem 0.8rem;
  padding-left: 0.4rem;
  background: #f8fafc;
  border: 1px solid var(--color-border);
  border-radius: 50px;
  transition: all 0.2s ease;
  color: var(--color-text);
  font-weight: 600;
  font-size: 0.9rem;
}

.user-profile-btn:hover, .user-profile-btn.active {
  background: white;
  border-color: var(--color-primary);
  box-shadow: var(--shadow-sm);
}

.avatar-small {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  overflow: hidden;
  background: #e2e8f0;
}

.avatar-small img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.logo-icon {
  color: var(--color-primary);
}

.logout-btn {
  color: var(--color-text-muted);
}

.logout-btn:hover {
  color: #d63031;
  background: #fff5f5;
}

@keyframes slide-down {
  from { transform: translateY(-100%); }
  to { transform: translateY(0); }
}

.animate-slide-down {
  animation: slide-down 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}

@media (max-width: 768px) {
  .user-name-label, .nav-menu span { display: none; }
  .nav-left, .nav-right { gap: 1rem; }
}
</style>
