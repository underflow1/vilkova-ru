<template>
  <div class="home">
    <p>
      <router-link to="/book/0">
        <img
          src="@/assets/cover.jpg"
          class="cover"
          alt="Обложка книги"
        />
      </router-link>
    </p>
    <div style="text-align: center;">
      Ирина Вилкова<br>
      <h2 style="margin: 1rem 0;">стихиИя</h2>
      Издание второе<br>
      Исправленное и дополненное
    </div>
    <div style="text-align: center; margin: 1rem 0;">
      <button
        @click="$router.push('/book/0')"
        class="mdc-button"
      >
        Читать стихи
      </button>
      <button
        @click="$parent.gotoOrder"
        class="mdc-button"
      >
        Купить книгу
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Home',

  mounted () {
    document.title = this.$root.title
  }
}
</script>

<style lang="scss">
  @import "~@/assets/theme";
  @import "~@material/button/mdc-button";

  .cover {
    width: 100%;
    height: auto;
  }
</style>
