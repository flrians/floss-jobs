<template>
  <div class="auth-page">
    <div class="auth-card card animate-fade">
      <div class="auth-header">
        <NuxtLink to="/" class="logo" style="justify-content: center; margin-bottom: 2rem;">
          <Briefcase :size="32" />
          <span>FlossJobs</span>
        </NuxtLink>
        <h2>{{ isSignUp ? 'Create Professional Account' : 'Welcome Back' }}</h2>
        <p>{{ isSignUp ? 'Join the leading job matching platform.' : 'Log in to manage your career journey.' }}</p>
      </div>
      
      <form @submit.prevent="handleAuth" class="auth-form">
        <div class="form-group">
          <label class="input-label">Email Address</label>
          <input 
            type="email" 
            class="input-field" 
            v-model="email" 
            required 
            placeholder="name@company.com"
          />
        </div>
        <div class="form-group">
          <label class="input-label">Password</label>
          <input 
            type="password" 
            class="input-field" 
            v-model="password" 
            required 
            placeholder="••••••••"
          />
        </div>
        
        <p v-if="error" class="error-msg">{{ error }}</p>
        
        <button type="submit" class="btn btn-primary btn-full" :disabled="loading">
          {{ loading ? 'Authenticating...' : (isSignUp ? 'Create Account' : 'Secure Login') }}
        </button>
      </form>
      
      <div class="auth-footer">
        <button @click="isSignUp = !isSignUp" class="btn btn-ghost btn-full">
          {{ isSignUp ? 'Already have an account? Log In' : 'New to FlossJobs? Create Account' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Briefcase } from 'lucide-vue-next';

const supabase = useSupabaseClient();
const email = ref('');
const password = ref('');
const loading = ref(false);
const isSignUp = ref(false);
const error = ref(null);
const router = useRouter();

const handleAuth = async () => {
  loading.value = true;
  error.value = null;
  
  try {
    if (isSignUp.value) {
      const { error: signUpError } = await supabase.auth.signUp({ 
        email: email.value, 
        password: password.value 
      });
      if (signUpError) throw signUpError;
      alert('Verification email sent! Please check your inbox.');
    } else {
      const { error: signInError } = await supabase.auth.signInWithPassword({ 
        email: email.value, 
        password: password.value 
      });
      if (signInError) throw signInError;
      router.push('/profile');
    }
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  background: var(--color-bg);
  background-image: 
    radial-gradient(at 0% 0%, rgba(0, 184, 148, 0.05) 0px, transparent 50%),
    radial-gradient(at 100% 100%, rgba(0, 206, 201, 0.05) 0px, transparent 50%);
}

.auth-card {
  width: 100%;
  max-width: 480px;
  padding: 3rem;
  box-shadow: var(--shadow-lg);
  border-radius: var(--radius-xl);
}

.auth-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.auth-header h2 {
  font-size: 1.75rem;
  margin-bottom: 0.5rem;
}

.auth-header p {
  color: var(--color-text-secondary);
}

.btn-full {
  width: 100%;
}

.auth-form {
  margin-bottom: 1.5rem;
}

.error-msg {
  color: #d63031;
  font-size: 0.85rem;
  margin-bottom: 1rem;
  background: #fff5f5;
  padding: 0.75rem;
  border-radius: 8px;
  border-left: 4px solid #d63031;
}
</style>
