<template>
  <div id="app" class="app">
    <router-view></router-view>
  </div>
</template>

<script>
    export default {
        name: 'app',
        mounted(){
            document.querySelectorAll('.modal button.button.is-success').forEach(element => {
                element.onclick = e => {
                    element.closest('.modal').classList.remove('is-active')
                }
            });
            document.querySelectorAll('.modal button[aria-label="close"]').forEach(element => {
                element.onclick = e => {
                    element.closest('.modal').classList.remove('is-active')
                }
            });
        }
    }
</script>

<style>
  @import "~bulma/css/bulma.css";
</style>
