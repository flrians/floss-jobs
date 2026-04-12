<template>
  <div class="profile-page">
    <main class="container page-content">
      <div class="profile-nav animate-fade">
        <button 
          @click="activeTab = 'personal'" 
          :class="['profile-nav-btn', { active: activeTab === 'personal' }]"
        >
          Personal Info
        </button>
        <button 
          @click="activeTab = 'preferences'" 
          :class="['profile-nav-btn', { active: activeTab === 'preferences' }]"
        >
          Job Preferences
        </button>
      </div>

      <div class="profile-card card animate-fade">
        <form @submit.prevent="handleSubmit" class="profile-form">
          
          <!-- Part 1: Identity -->
          <div v-if="activeTab === 'personal'" class="form-section fade-in">
            <h3 class="section-label">1. Professional Identity</h3>
            <div class="avatar-center">
              <div class="avatar-wrap">
                <img :src="profile.avatar_url || '/avatar.png'" alt="Avatar" />
                <div class="avatar-edit"><Camera :size="16" /></div>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group"><label class="input-label">First Name</label><input class="input-field" v-model="profile.first_name" required /></div>
              <div class="form-group"><label class="input-label">Last Name</label><input class="input-field" v-model="profile.last_name" required /></div>
            </div>
            <div class="form-row">
              <div class="form-group"><label class="input-label">Email</label><input class="input-field" v-model="profile.email" readonly /></div>
              <div class="form-group"><label class="input-label">Location</label><input class="input-field" v-model="profile.location" placeholder="E.g. Berlin" /></div>
            </div>
          </div>

          <!-- Part 2 & 3: Preferences -->
          <div v-if="activeTab === 'preferences'" class="fade-in">
            <div class="form-section">
              <h3 class="section-label">2. Search Targets & Salary</h3>
              <div class="form-row">
                <div class="form-group"><label class="input-label">Desired Job Title</label><input class="input-field" v-model="preferences.job_title" required /></div>
                <div class="form-group"><label class="input-label">Min. Annual Salary ($)</label><input class="input-field" type="number" v-model="preferences.min_salary" /></div>
              </div>
              <div class="form-row">
                <div class="form-group"><label class="input-label">Work Type</label><select class="input-field" v-model="preferences.work_type"><option value="Remote">Remote</option><option value="Hybrid">Hybrid</option><option value="On-site">On-site</option></select></div>
                <div class="form-group"><label class="input-label">Target Location</label><input class="input-field" v-model="preferences.location_preference" /></div>
              </div>
            </div>

            <div class="form-section">
              <h3 class="section-label">3. Career Deep Logic</h3>
              <div class="form-row">
                <div class="form-group">
                  <label class="input-label">Management Level</label>
                  <select class="input-field" v-model="preferences.management_level">
                    <option value="IC">Individual Contributor</option>
                    <option value="Team Lead">Team Lead</option>
                    <option value="Manager">Manager / Head of</option>
                    <option value="Director">Director / VP</option>
                    <option value="Executive">C-Level / Executive</option>
                  </select>
                </div>
                <div class="form-group">
                  <label class="input-label">Team Dynamic Preference</label>
                  <select class="input-field" v-model="preferences.team_dynamic">
                    <option value="Solo">Solo Expert / IC</option>
                    <option value="Small">Small Agile Team</option>
                    <option value="Collaborative">Collaborative Unit</option>
                    <option value="Cross-functional">Cross-functional Organization</option>
                  </select>
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label class="input-label">Travel Willingness</label>
                  <select class="input-field" v-model="preferences.travel_percentage">
                    <option value="0%">No Travel (0%)</option>
                    <option value="25%">Occasional (up to 25%)</option>
                    <option value="50%">Moderate (up to 50%)</option>
                    <option value="75%">High Travel (75%+)</option>
                  </select>
                </div>
                <div class="form-group">
                  <label class="input-label">Ideal Culture focus</label>
                  <select class="input-field" v-model="preferences.company_culture">
                    <option value="Innovation">Innovation & Speed</option>
                    <option value="Balance">Work-Life Balance</option>
                    <option value="Performance">Performance & Growth</option>
                    <option value="Stability">Stability & Legacy</option>
                  </select>
                </div>
              </div>

              <div class="form-group">
                <label class="input-label">Key Tech Stack / Industry Keywords</label>
                <input class="input-field" v-model="preferences.tech_stack_focus" placeholder="E.g. Vue.js, Fintech, Rust, AI" />
              </div>

              <div class="form-group" style="display: flex; align-items: center; gap: 1rem; padding-top: 1rem;">
                <input type="checkbox" id="relocate" v-model="preferences.ready_to_relocate" style="width: 20px; height: 20px; accent-color: var(--color-primary);" />
                <label for="relocate" class="input-label" style="margin-bottom: 0;">Open to Relocation?</label>
              </div>
            </div>
          </div>

          <div class="form-footer">
            <button type="submit" class="btn btn-primary btn-lg" :disabled="saving">
              {{ saving ? 'Updating...' : 'Save Changes' }}
              <Sparkles v-if="!saving" :size="20" style="margin-left: 0.75rem;" />
            </button>
          </div>
        </form>

        <div class="profile-actions">
          <button @click="handleLogout" class="btn btn-ghost btn-sm logout-btn">
            <LogOut :size="16" style="margin-right: 0.5rem;" />
            Logout from FlossJobs
          </button>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup>
import { Briefcase, Camera, Sparkles, LogOut } from 'lucide-vue-next';

const supabase = useSupabaseClient();
const user = useSupabaseUser();
const router = useRouter();

const activeTab = ref('personal'); // 'personal' or 'preferences'
const profile = ref({ first_name: '', last_name: '', email: '', location: '', avatar_url: '' });
const preferences = ref({
  job_title: '', min_salary: '', location_preference: '', work_type: 'Remote', ready_to_relocate: false,
  management_level: 'IC', team_dynamic: 'Small', travel_percentage: '0%', company_culture: 'Innovation', tech_stack_focus: ''
});
const saving = ref(false);

onMounted(() => {
  watchEffect(async () => {
    const { data: { session } } = await supabase.auth.getSession();
    const activeUser = session?.user || user.value;

    if (activeUser) {
      profile.value.email = activeUser.email;

      const [profileRes, prefRes] = await Promise.all([
        supabase.from('profiles').select('*').eq('id', activeUser.id).single(),
        supabase.from('job_preferences').select('*').eq('id', activeUser.id).single()
      ]);

      if (profileRes.data) profile.value = { ...profile.value, ...profileRes.data };
      if (prefRes.data) preferences.value = { ...preferences.value, ...prefRes.data };
    }
  });
});

const handleSubmit = async () => {
  const { data: { session } } = await supabase.auth.getSession();
  
  if (!session?.user) {
    alert('Session expired. Please log in again.');
    router.push('/login');
    return;
  }

  saving.value = true;
  
  try {
    const userId = session.user.id;
    
    const profileData = {
      id: userId,
      first_name: profile.value.first_name,
      last_name: profile.value.last_name,
      location: profile.value.location,
      email: profile.value.email,
      avatar_url: profile.value.avatar_url,
      updated_at: new Date()
    };

    const preferencesData = {
      id: userId,
      job_title: preferences.value.job_title,
      location_preference: preferences.value.location_preference,
      work_type: preferences.value.work_type,
      min_salary: preferences.value.min_salary,
      ready_to_relocate: preferences.value.ready_to_relocate,
      management_level: preferences.value.management_level,
      team_dynamic: preferences.value.team_dynamic,
      travel_percentage: preferences.value.travel_percentage,
      company_culture: preferences.value.company_culture,
      tech_stack_focus: preferences.value.tech_stack_focus,
      updated_at: new Date()
    };

    const results = await Promise.all([
      supabase.from('profiles').upsert(profileData),
      supabase.from('job_preferences').upsert(preferencesData)
    ]);
    const error = results.find(r => r.error);
    if (error) alert(error.error.message); else router.push('/jobs');
  } catch (err) { alert(err.message); } finally { saving.value = false; }
};
const handleLogout = async () => {
  await supabase.auth.signOut();
  router.push('/login');
};
</script>

<style scoped>
.page-content { padding: 1.5rem 0; }

.profile-nav {
  display: flex;
  justify-content: center;
  gap: 0.75rem;
  margin-bottom: 2rem;
}

.profile-nav-btn {
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

.profile-nav-btn:hover {
  color: var(--color-text);
  background: #f1f3f5;
}

.profile-nav-btn.active {
  color: var(--color-primary);
  background: var(--color-primary-light);
}

.profile-card { max-width: 800px; margin: 0 auto; border-radius: var(--radius-lg); box-shadow: var(--shadow-md); padding-bottom: 1.5rem; position: relative; overflow: hidden; }

.fade-in {
  animation: fadeIn 0.4s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.avatar-center { display: flex; justify-content: center; margin-bottom: 2rem; }
.avatar-wrap img { width: 90px; height: 90px; border-radius: 50%; border: 3px solid var(--color-primary); background: white; }
.section-label { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.1em; color: var(--color-primary); margin-bottom: 1.25rem; font-weight: 800; border-bottom: 1px solid var(--color-primary-light); display: inline-block; padding-bottom: 0.2rem; }
.form-section { margin-bottom: 1.5rem; padding: 0 3rem; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-bottom: 1.25rem; }
.form-footer { display: flex; justify-content: center; padding-top: 2rem; border-top: 1px solid var(--color-border); margin-top: 1.5rem; margin-bottom: 1rem; }
.profile-actions { display: flex; justify-content: center; padding: 0.5rem 0; }
.logout-btn { color: var(--color-text-secondary); border-color: transparent; font-size: 0.85rem; }
.logout-btn:hover { color: #d63031; background: #fff5f5; border-color: #fff5f5; }

@media (max-width: 768px) {
  .form-row { grid-template-columns: 1fr; }
  .form-section { padding: 0 1.5rem; }
}
</style>
