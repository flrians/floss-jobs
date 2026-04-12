<template>
  <div class="jobs-page">
    <main class="container page-content">
      <div class="jobs-sub-nav animate-fade">
        <div class="sub-nav-tabs">
          <button 
            @click="activeTab = 'matches'" 
            :class="['sub-nav-btn', { active: activeTab === 'matches' }]"
          >
            My Jobs
          </button>
          <button 
            @click="activeTab = 'favourites'" 
            :class="['sub-nav-btn', { active: activeTab === 'favourites' }]"
          >
            Favourites
          </button>
        </div>
        <p class="sub-nav-description">
          <span v-if="activeTab === 'matches'">High-precision matches based on your professional preferences.</span>
          <span v-else>Curated opportunities you've saved for consideration.</span>
        </p>
      </div>

      <div class="job-feed">
        <div v-if="loading" class="loading-state">
          <div class="pulse-ring"></div>
          <p>Analyzing matching opportunities...</p>
        </div>

        <div v-else class="job-list">
          <div 
            v-for="(job, index) in jobs" 
            :key="job.id"
            class="job-card card card-hover animate-fade"
            :style="{ '--delay': index * 0.1 + 's' }"
          >
            <div class="job-header">
              <div class="company-brand icon-box">
                <Briefcase :size="24" />
              </div>
              <div class="job-title-group">
                <h3>{{ job.title }}</h3>
                <p class="company-name">{{ job.company }}</p>
              </div>
              <div class="job-actions-top">
                <button @click="handleDismiss(job.id)" class="btn-dismiss" title="Dismiss match">
                  <X :size="18" />
                </button>
              </div>
              <div class="job-salary">
                <div class="badge">${{ job.salary / 1000 }}k / year</div>
              </div>
            </div>
            
            <div class="job-body">
              <div class="meta-row">
                <div class="meta-item">
                  <MapPin :size="16" />
                  <span>{{ job.location }}</span>
                </div>
                <div class="meta-item">
                  <Clock :size="16" />
                  <span>{{ job.work_type }}</span>
                </div>
              </div>
              <div class="tags-row">
                <span v-for="tag in job.tags" :key="tag" class="tag">{{ tag }}</span>
              </div>
            </div>
            
            <div class="job-footer">
              <button @click="navigateToDetail(job.id)" class="btn btn-primary">
                View Details <ExternalLink :size="16" style="margin-left: 0.5rem;" />
              </button>
              <button class="btn btn-ghost btn-icon">
                <Bookmark :size="18" />
              </button>
            </div>
          </div>

          <div v-if="jobs.length === 0" class="empty-state card">
            <Search :size="48" style="color: var(--color-text-muted); margin-bottom: 1.5rem;" />
            <h3>No matches found</h3>
            <p>Try refining your location preference or work type.</p>
            <NuxtLink to="/profile" class="btn btn-primary" style="margin-top: 2rem;">Adjust Preferences</NuxtLink>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { Briefcase, Settings, LogOut, MapPin, Clock, ExternalLink, Bookmark, Search, X } from 'lucide-vue-next';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const router = useRouter();

const profile = ref(null);
const preferences = ref(null);
const activeTab = ref('matches'); // 'matches' or 'favourites'
const loading = ref(true);
const dismissedIds = ref(new Set());
const allJobs = ref([]);

const jobs = computed(() => {
  if (activeTab.value === 'favourites') return []; // Mock empty favourites
  
  // Return all jobs (except dismissed ones) as requested
  return allJobs.value.filter(job => !dismissedIds.value.has(job.id));
});

const handleDismiss = (id) => {
  dismissedIds.value.add(id);
};

const navigateToDetail = (id) => {
  router.push(`/jobs/${id}`);
};

onMounted(async () => {
  const { data: { session } } = await supabase.auth.getSession();
  const activeUser = session?.user || user.value;

  if (!activeUser) {
    router.push('/login');
    return;
  }

  // Parallel fetch: Profile, Prefs, and Jobs
  const [profileRes, prefRes, jobsRes] = await Promise.all([
    supabase.from('profiles').select('*').eq('id', activeUser.id).single(),
    supabase.from('job_preferences').select('*').eq('id', activeUser.id).single(),
    supabase.from('jobs').select('*').order('created_at', { ascending: false })
  ]);

  profile.value = profileRes.data;
  preferences.value = prefRes.data;
  allJobs.value = jobsRes.data || [];
  loading.value = false;
});
</script>

<style scoped>
.page-content { padding: 2rem 0; }

.jobs-sub-nav {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 2rem;
}

.sub-nav-tabs {
  display: flex;
  gap: 0.75rem;
}

.sub-nav-description {
  font-size: 0.85rem;
  color: var(--color-text-secondary);
  font-weight: 500;
}

.sub-nav-btn {
  background: none;
  border: none;
  padding: 0.5rem 1.5rem;
  font-weight: 700;
  font-size: 0.95rem;
  color: var(--color-text-secondary);
  cursor: pointer;
  border-radius: 50px;
  transition: all 0.2s ease;
}

.sub-nav-btn:hover {
  color: var(--color-text);
  background: #f1f3f5;
}

.sub-nav-btn.active {
  color: var(--color-primary);
  background: var(--color-primary-light);
}

.job-list { display: flex; flex-direction: column; gap: 2rem; max-width: 850px; margin: 0 auto; }
.job-card { padding: 1.25rem 1.75rem; opacity: 0; animation: slideIn 0.5s ease-out forwards; animation-delay: var(--delay); position: relative; }
@keyframes slideIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
.job-header { display: flex; align-items: center; gap: 1.25rem; margin-bottom: 1rem; }
.job-title-group { flex: 1; }
.job-title-group h3 { font-size: 1.2rem; margin-bottom: 0.15rem; color: #1a1a1a; }
.company-name { color: var(--color-primary); font-weight: 700; font-size: 0.9rem; }
.job-body { margin-bottom: 1rem; }
.meta-row { display: flex; gap: 1.5rem; margin-bottom: 0.75rem; }
.meta-item { display: flex; align-items: center; gap: 0.4rem; font-size: 0.85rem; color: var(--color-text-secondary); }
.tags-row { display: flex; gap: 0.4rem; flex-wrap: wrap; }
.tag { background: #f1f3f5; padding: 0.2rem 0.6rem; border-radius: 6px; font-size: 0.75rem; font-weight: 600; color: var(--color-text-secondary); }
.job-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 1rem; border-top: 1px solid var(--color-border); }
.loading-state { text-align: center; padding: 3rem 0; }
.pulse-ring { width: 40px; height: 40px; border: 3px solid var(--color-primary-light); border-top-color: var(--color-primary); border-radius: 50%; margin: 0 auto 1.25rem; animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.empty-state { text-align: center; padding: 3rem; }
.job-actions-top {
  position: absolute;
  top: 1rem;
  right: 1.5rem;
}

.btn-dismiss {
  background: white;
  border: 1px solid var(--color-border);
  color: var(--color-text-muted);
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.btn-dismiss:hover {
  background: #fff5f5;
  color: #ff4757;
  border-color: #ff4757;
  transform: rotate(90deg);
}
</style>
