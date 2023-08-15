<template>
  <div class="home">
    <div class="cover-top">
      <router-link to="/book/0">
        <img
          src="@/assets/cover.jpg"
          alt="Обложка книги"
        />
      </router-link>
    </div>
    <div style="margin: 1rem 0; text-align: center;">
      Ирина Вилкова<br>
      <h2 style="margin: 1rem 0;">стихиИя</h2>
      Издание второе<br>
      Исправленное и дополненное
    </div>
    <div style="text-align: center; margin: 1rem 0;">
      <button
        @click="$parent.gotoFirst()"
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
    <div class="cover-bottom">
      <img
          src="@/assets/cover-bottom.png"
          alt="БИЗ MMXIX"
        />
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

  .cover-top {
    margin-bottom: 1.5rem;
    img {
      width: 100%;
      height: auto;
    }
  }

  .cover-bottom {
    text-align: center;
    margin-top: 1.5rem;
    img {
      width: 83px;
      height: 77px;
    }
  }
</style>
