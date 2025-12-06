<template>
    <div>
        <!-- Loading State -->
        <div v-if="state.loading" class="loading-overlay">
            <div class="spinner"></div>
            <p>Loading application...</p>
        </div>

        <!-- Error State -->
        <div v-else-if="state.error" class="error-overlay">
            <h3>⚠️ Configuration Error</h3>
            <p>{{ state.error }}</p>
            <button @click="loadClientConfig">Retry</button>
        </div>

        <!-- Main Content (only shows when config is loaded) -->
        <div v-else>

            <ListModal 
                ref="popularModalRef"
                :modal-id="'popularModal'"
                :title="'Trakt Popular Lists'"
                :items="state.lists_popular"
                :loading="state.lists_loading.popular"
                :pagination="state.pagination_popular"
                :list-type="'popular'"
                @add-list="addList"
                @close="closeModal('popular')"
                @page-change="handlePageChange"
                @opened="onModalOpened('popular')"
                @closed="onModalClosed('popular')"                
            />

            <ListModal 
                ref="trendingModalRef"
                :modal-id="'trendingModal'"
                :title="'Trakt Trending Lists'"
                :items="state.lists_trending"
                :loading="state.lists_loading.trending"
                :pagination="state.pagination_trending"
                :list-type="'trending'"
                @add-list="addList"
                @close="closeModal('trending')"
                @page-change="handlePageChange"
                @opened="onModalOpened('trending')"
                @closed="onModalClosed('trending')"
            />

            <ListModal 
                ref="personalModalRef"
                :modal-id="'personalModal'"
                :title="'Trakt Personal Lists'"
                :items="state.lists_personal"
                :loading="state.lists_loading.personal"
                :pagination="state.pagination_personal"
                :list-type="'personal'"
                @add-list="addList"
                @close="closeModal('personal')"
                @page-change="handlePageChange"
                @opened="onModalOpened('personal')"
                @closed="onModalClosed('personal')"
            />

            <ListModal 
                ref="likedModalRef"
                :modal-id="'likedModal'"
                :title="'Trakt Liked Lists'"
                :items="state.lists_liked"
                :loading="state.lists_loading.liked"
                :pagination="state.pagination_liked"
                :list-type="'liked'"
                @add-list="addList"
                @close="closeModal('liked')"
                @page-change="handlePageChange"
                @opened="onModalOpened('liked')"
                @closed="onModalClosed('liked')"
            />

            <ListModal 
                ref="searchModalRef"
                :modal-id="'searchModal'"
                :title="'Search Trakt Lists'"
                :items="state.lists_search"
                :loading="state.lists_loading.search"
                :pagination="state.pagination_search"
                :list-type="'search'"
                v-model:search-query="state.searchQuery"
                @add-list="addList"
                @close="closeModal('search')"
                @page-change="handlePageChange"
                @opened="onModalOpened('search')"
                @closed="onModalClosed('search')"
                @search="performSearch"
            />
        

            <!-- install Modal -->
            <div id="installModal" ref='installModal' tabindex="-1" aria-hidden="true"
                class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 w-full md:inset-0 h-modal md:h-full justify-center items-center">
                <div class="relative p-4 w-full max-w-2xl h-full md:h-auto">
                    <!-- Modal content -->
                    <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
                        <!-- Modal header -->
                        <div class="modal-header">

                            <div class="flex justify-between items-start p-4 rounded-t border-b dark:border-gray-600">
                                <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                    Install the addon
                                </h3>
                                <button @click="state.install.hide();" type="button"
                                    class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center dark:hover:bg-gray-600 dark:hover:text-white"
                                    data-modal-toggle="defaultModal">
                                    <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"
                                        xmlns="http://www.w3.org/2000/svg" data-darkreader-inline-fill=""
                                        style="--darkreader-inline-fill:currentColor;">
                                        <path fill-rule="evenodd"
                                            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                            clip-rule="evenodd"></path>
                                    </svg>
                                    <span class="sr-only">Close modal</span>
                                </button>
                            </div>
                        </div>
                        <!-- Modal body -->
                        <div class="p-6 space-y-6">
                            <div>
                                <b class="text-base leading-relaxed text-gray-500 dark:text-gray-400">
                                    From the river to the sea, Palestine will be free.
                                </b>
                            </div>
                            <div>
                                <p class="text-base leading-relaxed text-gray-500 dark:text-gray-400">
                                    huge thanks to Rab1t for his tremendous help.</p>
                            </div>
                        </div>
                        <!-- Modal footer -->
                        <div class="footer-modal">
                            <div
                                class="flex items-center p-6 space-x-2 rounded-b border-t border-gray-200 dark:border-gray-600">
                                <a id="install_button" href="#"><button type="button"
                                        class="footer-button text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Install
                                        Addon</button></a>
                                <button @click="copyToClipboard();"
                                    class="footer-button inline-flex items-center py-2 px-3 text-gray-500 bg-white hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-blue-300 rounded-lg border border-gray-200 text-sm font-medium px-5 py-2.5 hover:text-gray-900 focus:z-10 dark:bg-gray-700 dark:text-gray-300 dark:border-gray-500 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-600">
                                    <svg aria-hidden="true" class="w-2r" fill="currentColor" viewBox="5 0 36 36"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <path
                                            d="M22.6,4H21.55a3.89,3.89,0,0,0-7.31,0H13.4A2.41,2.41,0,0,0,11,6.4V10H25V6.4A2.41,2.41,0,0,0,22.6,4ZM23,8H13V6.25A.25.25,0,0,1,13.25,6h2.69l.12-1.11A1.24,1.24,0,0,1,16.61,4a2,2,0,0,1,3.15,1.18l.09.84h2.9a.25.25,0,0,1,.25.25Z"
                                            class="clr-i-outline clr-i-outline-path-1"></path>
                                        <path
                                            d="M33.25,18.06H21.33l2.84-2.83a1,1,0,1,0-1.42-1.42L17.5,19.06l5.25,5.25a1,1,0,0,0,.71.29,1,1,0,0,0,.71-1.7l-2.84-2.84H33.25a1,1,0,0,0,0-2Z"
                                            class="clr-i-outline clr-i-outline-path-2"></path>
                                        <path d="M29,16h2V6.68A1.66,1.66,0,0,0,29.35,5H27.08V7H29Z"
                                            class="clr-i-outline clr-i-outline-path-3"></path>
                                        <path
                                            d="M29,31H7V7H9V5H6.64A1.66,1.66,0,0,0,5,6.67V31.32A1.66,1.66,0,0,0,6.65,33H29.36A1.66,1.66,0,0,0,31,31.33V22.06H29Z"
                                            class="clr-i-outline clr-i-outline-path-4"></path>
                                    </svg>
                                    Copy to clipboard
                                </button>
                            </div>
                            <div
                                class="flex items-center p-6 space-x-2 rounded-b border-t border-gray-200 dark:border-gray-600">
                                <button type="button" @click="state.install.hide();"
                                    class="text-gray-500 bg-white hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-blue-300 rounded-lg border border-gray-200 text-sm font-medium px-5 py-2.5 hover:text-gray-900 focus:z-10 dark:bg-gray-700 dark:text-gray-300 dark:border-gray-500 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-600">Cancel</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Background with dynamic URL -->
            <div class="bg-img relative min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8 bg-gray-500 bg-no-repeat bg-cover bg-center relative items-center"
                :style="`background-image: url(${clientConfig.backgroundUrl});`">
                <div class="absolute bg-black opacity-60 inset-0 z-0"></div>

                <div class="flex flex-col rounded-xl bg-white shadow-lg z-10">
                    <div class="bg-gradient rounded-top max-w-md w-full space-y-8 p-10">

                        <div class="items-center header">
                            <img class="logo" :src="`${clientConfig.logoUrl}`">
                            <h1 class="font-semibold text-lg mr-auto">{{ clientConfig.name }}</h1>
                            <h2 class="font-semibold text-lg mr-auto" style="text-align: right;">Version: {{
                                    clientConfig.version
                                }}</h2>
                            <p class="mt-5">{{ clientConfig.description }}</p>
                        </div>
                    </div>
                    <div class="max-w-md w-full space-y-8 p-10">


                        <div class="grid gap-8 grid-cols-1">
                            <div class="flex flex-col">

                                <div class="flex items-center justify-center space-x-2 mt-5">
                                    <span class="h-px w-full bg-gray-200"></span>
                                </div>

                                <div class="items-center mt-5 description">
                                    <h2 class="font-semibold text-lg mr-auto">This addon has more:</h2>
                                    <ul v-html="stylizedTypes.map(t => `<li>${t}</li>`).join('')"></ul>
                                </div>

                                <div class="flex items-center justify-center space-x-2 mt-5">
                                    <span class="h-px w-full bg-gray-200"></span>
                                </div>

                                <div class="mt-10">
                                    <span class="text-xs font-semibold text-gray-600 py-2">Auth your trakt account to be
                                        able to get private lists, watchlist and recommendations</span>
                                    <div class="mt-5 flex flex-col items-center">
                                        <a 
                                            id="Auth"
                                            :href="authButtonState.href"
                                            :style="{
                                                backgroundColor: authButtonState.backgroundColor,
                                                color: 'white',
                                                padding: '12px 24px',
                                                borderRadius: '9999px',
                                                textDecoration: 'none',
                                                display: 'inline-block',
                                                cursor: authButtonState.disabled ? 'not-allowed' : 'pointer',
                                                opacity: authButtonState.disabled ? 0.7 : 1
                                            }"
                                            @click="authButtonState.disabled ? $event.preventDefault() : null"
                                            class="hover:opacity-90 transition-opacity"
                                        >
                                            {{ authButtonState.text }}
                                        </a>
                                    </div>
                                </div>
                            <div v-if="state.user">
                                <span v-if="state.user.name" class="text-xs font-semibold text-gray-600 py-2"> 
                                    Logged in as: {{ state.user.name }}<br> Username: {{state.user.username}} , Private: {{state.user.private}}
                                </span>
                                
                            </div>
                            <span v-if="state.expires" class="text-xs font-semibold text-gray-600 py-2">token expires
                                    on: {{ new Date(state.expires * 1000).toLocaleString() }}.</span>

                                <div class="flex items-center justify-center space-x-2 mt-10">
                                    <span class="h-px w-full bg-gray-200"></span>
                                </div>


                                <span class="text-xs font-semibold text-gray-600 py-2 mt-10">Add lists</span>

                                <div class="flex flex-col gap-5 mt-5 w-full" role="group">
                                    <!-- First row -->
                                    <div class="flex rounded-md shadow-sm w-full" role="group">
                                        <button @click="showModal('popular')" type="button"
                                            class="flex-1 py-2 px-4 text-sm font-medium text-gray-900 bg-white border border-gray-300 rounded-l-md hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 dark:bg-gray-700 dark:border-gray-500 dark:text-white dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-blue-500 dark:focus:text-white">
                                            Browse popular lists
                                        </button>
                                        <button @click="showModal('trending')" type="button"
                                            class="flex-1 py-2 px-4 text-sm font-medium text-gray-900 bg-white border-t border-b border-r border-gray-300 rounded-r-md hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 dark:bg-gray-700 dark:border-gray-500 dark:text-white dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-blue-500 dark:focus:text-white">
                                            Browse trending lists
                                        </button>
                                    </div>

                                    <!-- Second row -->
                                    <div class="flex rounded-md shadow-sm w-full" role="group">
                                        <button @click="showModal('personal')" type="button"
                                            class="flex-1 py-2 px-4 text-sm font-medium text-gray-900 bg-white border border-gray-300 rounded-l-md hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 dark:bg-gray-700 dark:border-gray-500 dark:text-white dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-blue-500 dark:focus:text-white">
                                            Browse personal lists (requires login)
                                        </button>
                                        <button @click="showModal('liked')" type="button"
                                            class="flex-1 py-2 px-4 text-sm font-medium text-gray-900 bg-white border-t border-b border-r border-gray-300 rounded-r-md hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-2 focus:ring-blue-700 focus:text-blue-700 dark:bg-gray-700 dark:border-gray-500 dark:text-white dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-blue-500 dark:focus:text-white">
                                            Browse liked lists (requires login)
                                        </button>
                                    </div>
                                </div>

                                <div class="flex items-center justify-center space-x-2 mt-5">
                                    <span class="h-px w-16 bg-gray-300"></span>
                                    <span class="text-gray-400 font-normal">or</span>
                                    <span class="h-px w-16 bg-gray-300"></span>
                                </div>

                                <div class="mt-5">
                                    <form @submit.prevent="searchLists">
                                        <label for="searchInput"
                                            class="mb-2 text-sm font-medium text-gray-900 sr-only dark:text-gray-300">Search
                                            Trakt lists</label>
                                        <div class="relative">
                                            <div
                                                class="flex absolute inset-y-0 left-0 items-center pl-3 pointer-events-none">
                                                <svg aria-hidden="true" class="w-5 h-5 text-gray-500 dark:text-gray-400"
                                                    fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                                    xmlns="http://www.w3.org/2000/svg">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                        d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                                                </svg>
                                            </div>
                                            <input v-model="state.searchQuery" type="search" id="searchInput"
                                                class="block p-4 pl-10 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                                                placeholder="Search Trakt lists" required>
                                            <button type="submit"
                                                class="text-white absolute right-2.5 bottom-2.5 bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Search</button>
                                        </div>
                                    </form>

                                </div>

                                <div class="flex items-center justify-center space-x-2 mt-5">
                                    <span class="h-px w-16 bg-gray-300"></span>
                                    <span class="text-gray-400 font-normal">or</span>
                                    <span class="h-px w-16 bg-gray-300"></span>
                                </div>

                                <div class="mt-5">
                                    <form @submit.prevent="addListUrl">
                                        <label for="urlInput"
                                            class="mb-2 text-sm font-medium text-gray-900 sr-only dark:text-gray-300">Paste
                                            list
                                            URL</label>
                                        <div class="relative">
                                            <div
                                                class="flex absolute inset-y-0 left-0 items-center pl-3 pointer-events-none">
                                                <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                    class="w-5 h-5 text-gray-500 dark:text-gray-400" viewBox="0 0 24 24"
                                                    stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                        d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z">
                                                    </path>
                                                </svg>
                                            </div>
                                            <input v-model="state.listUrl" type="search" id="urlInput"
                                                class="block p-4 pl-10 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                                                placeholder="Paste list URL" required>
                                            <button type="submit"
                                                class="text-white absolute right-2.5 bottom-2.5 bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Add
                                                list</button>
                                        </div>
                                    </form>
                                    <small><b>Note:</b> adding private lists requires Trakt login.</small>
                                </div>

                                <div class="flex items-center justify-center space-x-2 mt-10">
                                    <span class="h-px w-full bg-gray-200"></span>
                                </div>

                                <div class="mt-5">
                                    <small><b>RPDB key:</b> <a href="https://ratingposterdb.com/api-key/" target="_blank"
                                            class="text-xs font-semibold text-gray-600 py-2">RPDB API (?)</a></small>


                                    <form @submit.prevent="ValidateRPDB">

                                        <div class="relative flex">
                                            <input v-model="state.RPDBkey.key" id="RPDB"
                                                class="block p-4 pl-10 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
                                                placeholder="Paste RPDB API Key (optional)" required>
                                            <button type="submit"
                                                class="text-white absolute right-2.5 bottom-2.5 bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Validate
                                                key</button>
                                        </div>
                                        <small v-if="state.RPDBkey.valid !== null">key is: <b v-if="state.RPDBkey.valid"
                                                style="color: green;">Valid</b><b v-if="!state.RPDBkey.valid"
                                                style="color: red;">Invalid</b></small>


                                        <div class="relative" v-if="state.RPDBkey.valid">
                                            <small>Poster type:</small>
                                            <dropdown class="sorting-dropdown" :options="state.RPDBkey.posters"
                                                :selected="{ name: state.RPDBkey.poster }" v-on:updateOption="RPDBposter"
                                                :placeholder="'Select poster type'" :closeOnOutsideClick="true">
                                            </dropdown>
                                        </div>
                                    </form>

                                </div>

                                <div class="flex items-center justify-center space-x-2 mt-10">
                                    <span class="h-px w-full bg-gray-200"></span>
                                </div>

                                <div class="mt-10">
                                    <span class="text-xs font-semibold text-gray-600 py-2">Generic lists</span>
                                    <draggable v-model="state.genericLists" group="generics" item-key="element.id"
                                        :handle="'.drag-handle'"
                                        :cancel="'.no-drag'"
                                        :preventOnFilter=false
                                        @start="state.genericDrag = true" @end="state.genericDrag = false"
                                        class="mt-5 w-full text-sm font-medium text-gray-900 bg-white rounded-lg border border-gray-200 dark:bg-gray-700 dark:border-gray-600 dark:text-white">
                                        <template #item="{ element }">
                                            <div
                                                class="grabbable py-2 px-4 w-full rounded-t-lg border-b border-gray-200 dark:border-gray-600 flex">
                                                <div class="flex">
                                                    <span class="drag-handle mr-2 dragable-title">
                                                        {{ element.name }}
                                                    </span>
                                                    <div class="no-drag flex">
                                                        <VueToggles class="separated-toggle"
                                                            v-if="element.id === 'trakt_watchlist'"
                                                            :value="element.separated"
                                                            @click="element.separated = !element.separated"
                                                            uncheckedText="Merged" checkedText="Divided" />
                                                        <VueToggles :value="element.value"
                                                            @click="element.value = !element.value" uncheckedText="Disabled"
                                                            checkedText="Enabled" />
                                                    </div>
                                                </div>
                                                <div class="no-drag flex flex-even">
                                                    <dropdown v-if="element.sortable" class="sorting-dropdown"
                                                        :options="Consts.SortOptions"
                                                        :selected="{ name: getSorting(element.sort), value: element.sort }"
                                                        v-on:updateOption="updateSorting($event, element)"
                                                        :placeholder="'sort by'" :closeOnOutsideClick="true">
                                                    </dropdown>
                                                    <dropdown v-if="element.sortable" class="sorting-dropdown"
                                                        :options="Consts.SortDirections"
                                                        :selected="{ name: getDirection(element.sort, element.direction), value: element.direction }"
                                                        v-on:updateOption="updateSortingDirection($event, element)"
                                                        :placeholder="'sorting direction'" :closeOnOutsideClick="true">
                                                    </dropdown>
                                                </div>
                                            </div>
                                        </template>
                                    </draggable>
                                    <span class="text-xs font-semibold text-gray-600 py-2">Trakt lists</span>
                                    <draggable v-if="state.lists.length" v-model="state.lists" group="lists"
                                        :handle="'.drag-handle'"
                                        :cancel="'.no-drag'"
                                        :preventOnFilter=false 
                                        item-key="element.id" @start="state.drag = true" @end="state.drag = false"
                                        class="mt-5 w-full text-sm font-medium text-gray-900 bg-white rounded-lg border border-gray-200 dark:bg-gray-700 dark:border-gray-600 dark:text-white">
                                        <template #item="{ element }">
                                            <div
                                                class="grabbable py-2 px-4 w-full rounded-t-lg border-b border-gray-200 dark:border-gray-600 flex">
                                                <div class="drag-handle flex">
                                                    <span class="mr-2 dragable-title">
                                                        {{ element.name || element.slug }}
                                                    </span>
                                                    <span style="line-height: 32px;"
                                                        class="bg-blue-100 text-blue-800 text-xs font-semibold px-2.5 py-0.5 rounded dark:bg-blue-200 dark:text-blue-800 mr-2">
                                                        {{ element.username }}
                                                    </span>
                                                    <div class="no-drag flex">
                                                        <button type="button"
                                                            class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 inline-flex items-center dark:hover:bg-gray-600 dark:hover:text-white"
                                                            @click="removeList(element)">
                                                            <svg aria-hidden="true" class="w-5 h-5" fill="currentColor"
                                                                viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                                                                <path fill-rule="evenodd"
                                                                    d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                                                    clip-rule="evenodd">
                                                                </path>
                                                            </svg>
                                                            <span class="sr-only">Remove list</span>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="no-drag flex flex-even">
                                                    <dropdown class="sorting-dropdown" :options="Consts.SortOptions"
                                                        :selected="{ name: getSorting(element.sort), value: element.sort }"
                                                        v-on:updateOption="updateSorting($event, element)"
                                                        :placeholder="'Select default sorting'" :closeOnOutsideClick="true">
                                                    </dropdown>
                                                    <dropdown class="sorting-dropdown" :options="Consts.SortDirections"
                                                        :selected="{ name: getDirection(element.sort, element.direction), value: element.direction }"
                                                        v-on:updateOption="updateSortingDirection($event, element)"
                                                        :placeholder="'sorting direction'" :closeOnOutsideClick="true">
                                                    </dropdown>
                                                </div>
                                            </div>
                                        </template>
                                    </draggable>
                                    <div v-else class="text-gray-500 mt-5">
                                        <p>No lists added</p>
                                    </div>
                                </div>

                                <div class="flex items-center justify-center space-x-2 mt-10">
                                    <span class="h-px w-full bg-gray-200"></span>
                                </div>

                                <div class="mt-10 flex flex-col">
                                    <button @click="state.install.show(); generateInstallUrl();" type="button"
                                        class="text-white bg-blue-700 hover:bg-blue-800 focus:outline-none focus:ring-4 focus:ring-blue-300 font-medium rounded-full text-sm px-5 py-2.5 text-center mr-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">Install
                                        Addon</button>
                                </div>


                                <div class="mt-5 flex flex-col">
                                    <p class="text-center text-gray-400">This addon was created by<br />
                                        <a href="https://github.com/dexter21767" target="_blank"
                                            class="text-purple-700">dexter21767</a>
                                        and
                                        <a href="https://github.com/rleroi" target="_blank"
                                            class="text-purple-700">rab1t</a>
                                        .<!--<br> Background by:
                                <a href="https://twitter.com/art_pengu" target="_blank" class="text-purple-700">Bahadır
                                    Parıldar</a>-->
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { Buffer } from 'buffer';
import draggable from 'vuedraggable';
import axios from 'axios';
import { reactive, ref, onMounted, computed, nextTick, watch } from 'vue';
import { toast } from 'vue3-toastify'
import { Modal, Dropdown } from 'flowbite'
import { useHead } from "@vueuse/head";
import dropdown from 'vue-dropdowns';
import VueToggles from "vue-toggles";
import ListModal from './components/ListModal.vue'

// Load sort options from static JSON
import * as sortOpts from '../../sortOpts.json';

// ========== FIX 1: useHead() must be called unconditionally ==========
const pageTitle = ref('Loading...');
const pageIcon = ref('/public/logoPS.png');

useHead({
    title: pageTitle,
    link: [
        {
            rel: "icon",
            type: "image/svg+xml",
            href: pageIcon,
        }
    ],
});

// Reactive client configuration - starts empty
const clientConfig = ref({
  version: '1.0.0',      
  name: 'Trakt TV',
  description: '',
  logoUrl: '',
  backgroundUrl: '',
  types: [],
  baseUrl: '',
  oauthClientId: '' 
});

// Loading and error states
const state = reactive({
    loading: true,
    error: null,
    url: '',
    searchResults: [],
    searchQuery: '',
    searchPagination: null,
    listUrl: '',
    drag: false,
    genericDrag: false,
    lists: [],
    modal: null,
    genericLists: [],
    lists_popular: null,
    lists_trending: null,
    lists_personal: null,
    lists_search: null,
    lists_liked: null,
    pagination_popular: null,
    pagination_trending: null,
    pagination_personal: null,
    pagination_search: null,
    pagination_liked: null,
    lists_loading: {
        popular: false,
        trending: false,
        personal: false,
        search: false,
        liked: false
    },
    install: null,
    accessToken: null,
    refreshToken: null,
    expires: null,
    expired: false,
    timeLeft: null,
    user: {},
    RPDBkey: { key: null, valid: null, poster: 'poster-default', posters: null, tier: null },
    authButtonInitialized: false, // Track if auth button has been initialized
    lastSearchQuery: ''
});

// Computed property for stylized types - safe with fallback
const stylizedTypes = computed(() => {
    if (!clientConfig.value.types || !Array.isArray(clientConfig.value.types)) {
        return [];
    }
    return clientConfig.value.types.map(t => t[0].toUpperCase() + t.slice(1));
});

// Constants from sortOpts
const Consts = { ...sortOpts };

// Check if search modal is open
function isSearchModalOpen() {
    const isOpen = searchModalRef.value?.isOpen || 
                   state.searchModalVisible || 
                   false;
    
    console.log('isSearchModalOpen check:', {
        modalRef: searchModalRef.value,
        isOpen: searchModalRef.value?.isOpen,
        stateModalVisible: state.searchModalVisible,
        finalResult: isOpen
    });
    
    return isOpen;
}

// ========== FIX 2: Watch for config changes to update head ==========
watch(() => clientConfig.value, (newConfig) => {
    if (newConfig.name) {
        pageTitle.value = newConfig.name + ' - Stremio Addon';
        pageIcon.value = newConfig.logoUrl || '/public/logoPS.png';
    }
}, { deep: true, immediate: true });

// Load client config from JSON file
async function loadClientConfig() {
    state.loading = true;
    state.error = null;
    
    try {
        const response = await fetch('/public/client-config.json');
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        
        // Merge with defaults (preserve defaults if data is missing)
        clientConfig.value = {
            ...clientConfig.value, // Defaults
            ...data,              // Loaded data
        };
        
        console.log('Client config loaded:', clientConfig.value);
        
        // Set current URL based on loaded config
        Consts.currentUrl = (window.location.origin == "http://localhost:5173") 
            ? 'http://127.0.0.1:63355' 
            : (clientConfig.value.baseUrl || window.location.origin);
        
    } catch (error) {
        console.error('Failed to load client config:', error);
        state.error = error.message;
        
        // Set minimal safe fallbacks
        clientConfig.value.logoUrl = '/public/logoPS.png?ver=1.0.0';
        clientConfig.value.backgroundUrl = '/public/background.png?ver=1.0.0';
        clientConfig.value.baseUrl = window.location.origin;
        
        // Fallback current URL
        Consts.currentUrl = (window.location.origin == "http://localhost:5173") 
            ? 'http://127.0.0.1:63355' 
            : window.location.origin;
        
    } finally {
        state.loading = false;
    }
}

// ========== FIX 3: Safer OAuth URL update ==========
function updateOAuthUrl() {
    if (!clientConfig.value.oauthClientId) {
        console.warn('No OAuth client ID available');
        return;
    }
    
    // Wait for DOM to be ready
    nextTick(() => {
        const authElement = document.getElementById('Auth');
        if (!authElement) {
            console.warn('Auth element not found, will retry on next tick');
            setTimeout(updateOAuthUrl, 100);
            return;
        }
        
        const redirectUri = encodeURIComponent(Consts.currentUrl);
        const oauthUrl = `https://trakt.tv/oauth/authorize?client_id=${clientConfig.value.oauthClientId}&redirect_uri=${redirectUri}&response_type=code`;
        
        if (authElement.parentNode) {
            authElement.parentNode.href = oauthUrl;
            console.log('OAuth URL updated:', oauthUrl);
            state.authButtonInitialized = true;
        }
    });
}

// Watch for OAuth client ID changes
watch(() => clientConfig.value.oauthClientId, (newId) => {
    if (newId) {
        updateOAuthUrl();
    }
});

const installModal = ref();
const popularModalRef = ref();
const trendingModalRef = ref();
const searchModalRef = ref();
const personalModalRef = ref();
const likedModalRef = ref();

const client = axios.create({
    baseURL: Consts.currentUrl,
    timeout: 10000,
});

onMounted(async () => {
    // Load client config FIRST
    await loadClientConfig();
    
    // Then initialize the rest
    Consts.Config = (window.location.pathname && window.location.pathname.split('/')) 
        ? Consts.Config = window.location.pathname.replace('configure', '').replaceAll('/', '') 
        : undefined;
    
    state.genericLists = [
        { id: "trakt_popular", name: "Popular", value: true, order: 0 }, 
        { id: "trakt_trending", name: "Trending", value: true, order: 1 }, 
        { id: "trakt_watchlist", name: "WatchList", value: false, order: 2, sortable: true, separated: false }, 
        { id: "trakt_rec", name: "Recommendations", value: false, order: 3 }, 
        { id: "trakt_search", name: "Search", value: true, order: 4 }
    ];

    loadConfig();
    getListsOflists();
    generateInstallUrl();

    // Initialize modals AFTER DOM is ready
    nextTick(() => {
        state.install = new Modal(installModal.value);
    });
    
    // Try to update OAuth URL after everything is initialized
    setTimeout(updateOAuthUrl, 500);
});

// Function to show modal
const showModal = async (modalType) => {
    // Get the modal ref
    const modalRef = getModalRef(modalType)
    
    if (modalRef?.value?.show) {
        // Show the modal
        modalRef.value.show()
        
        // Load data if needed
        if (shouldLoadData(modalType)) {
            await loadPage(modalType)
        }
    }
}

// Function to close modal
const closeModal = async (modalType) => {
    // Get the modal ref
    const modalRef = getModalRef(modalType)
    
    if (modalRef?.value?.show) {
        // Show the modal
        modalRef.value.hide()                
    }
}

// Helper function to get modal ref
const getModalRef = (modalType) => {
    switch (modalType) {
        case 'personal': return personalModalRef
        case 'liked': return likedModalRef
        case 'popular': return popularModalRef
        case 'trending': return trendingModalRef
        case 'search': return searchModalRef
        default: return null
    }
}

// Helper function to check if data should be loaded
const shouldLoadData = (modalType) => {
    const lists = {
        personal: state.lists_personal,
        liked: state.lists_liked,
        popular: state.lists_popular,
        trending: state.lists_trending,
        search: state.lists_search
    }
    
    return !lists[modalType] || lists[modalType].length === 0
}

// Modal event handlers
const onModalOpened = (modalType) => {
    console.log(`${modalType} modal opened`)
    // Any logic you need when modal opens
}

const onModalClosed = (modalType) => {
    console.log(`${modalType} modal closed`)
    // Any cleanup when modal closes
}


// Add reactive state for OAuth button
const authButtonState = reactive({
    text: 'Login to Trakt.tv',
    backgroundColor: 'red',
    href: '#',
    disabled: false
});

// Update OAuth button based on state
function updateOAuthButton() {
    if (state.accessToken && state.expires && !state.expired) {
        authButtonState.text = 'Authenticated';
        authButtonState.backgroundColor = 'blue';
        authButtonState.href = '';
        authButtonState.disabled = true;
    } else if (state.expired && state.refreshToken) {
        authButtonState.text = 'Re-authenticate';
        authButtonState.backgroundColor = 'red';
        authButtonState.href = Consts.Config 
            ? `${Consts.currentUrl}/${Consts.Config}/?refresh_token=${state.refreshToken}` 
            : `${Consts.currentUrl}/?refresh_token=${state.refreshToken}`;
        authButtonState.disabled = false;
    } else {
        authButtonState.text = 'Login to Trakt.tv';
        authButtonState.backgroundColor = 'red';
        
        if (clientConfig.value.oauthClientId) {
            const redirectUri = encodeURIComponent(Consts.currentUrl);
            authButtonState.href = `https://trakt.tv/oauth/authorize?client_id=${clientConfig.value.oauthClientId}&redirect_uri=${redirectUri}&response_type=code`;
            authButtonState.disabled = false;
        } else {
            authButtonState.href = '#';
            authButtonState.disabled = true;
        }
    }
}

// Call this when auth state changes
watch(() => [state.accessToken, state.expired, state.refreshToken], () => {
    updateOAuthButton();
}, { immediate: true });

// Also update when client config loads
watch(() => clientConfig.value.oauthClientId, () => {
    updateOAuthButton();
});

// ========== Modified loadToken function ==========
function loadToken(config = {}){
    console.log('config', config);
    if (config.access_token) {
        state.accessToken = config.access_token;
        state.refreshToken = config.refresh_token || state.refreshToken;
        state.expires = config.expires || state.expires;
    }

    const searchParams = new URLSearchParams(window.location.search);
    if (searchParams.has('access_token')) {
        state.accessToken = searchParams.get('access_token');
        if (searchParams.has('refresh_token'))
            state.refreshToken = searchParams.get('refresh_token');

        if (searchParams.has('expires')) {
            state.expires = parseInt(searchParams.get('expires'));
            const currentTime = new Date().getTime() / 1000;
            state.expired = currentTime > state.expires;
            state.timeLeft = currentTime - state.expires;
            if (state.expired) state.accessToken = null;
        }
    }
    
    // Safe user profile loading
    getUserProfile().finally(() => {
        // Update auth button AFTER user profile is loaded (or failed)
        updateOAuthButton();
    });
} 

// ========== Modified getUserProfile with better error handling ==========
async function getUserProfile() {
    if (!state.accessToken) {
        state.user = {};
        return;
    }
    
    try {
        const response = await axios.get(Consts.currentUrl + '/getUserProfile', { 
            params: { access_token: state.accessToken } 
        });
        state.user = response.data;
    } catch (error) {
        if (error.response?.status === 401) {
            state.accessToken = null;
            state.refreshToken = null;
            state.expires = null;
            state.user = {};
        } else {
            console.error('Error fetching user profile:', error);
        }
    }
}

function loadConfig() {
    let configuration = Consts.Config;
    if (!configuration) return;

    if (!configuration.startsWith('lists')) configuration = Buffer.from(configuration, 'base64').toString();
    let config = JSON.parse(configuration);
    loadToken(config);

    for (let i = 0; i < config.ids.length; i++) {
        let id = config.ids[i];
        let [username, slug, sortOpt] = id.split(':');
        let [sort, direction] = sortOpt.split(',');
        state.lists.push({
            name: slug,
            slug: slug,
            username: username,
            sort: sort || sortOpt,
            direction: direction
        });
    }

    if (config.lists && config.lists.length) {
        state.genericLists.forEach((list, index) => {
            const val = config.lists.find(l => l.includes(list.id)) || '';
            const [id, secondPart, thirdPart] = val.split(':');

            if (id) list.value = true;
            else list.value = false;
            if (id === "trakt_watchlist") {
                if (secondPart == "separated") {
                    list.separated = true;
                    list.sort = thirdPart;
                } else {
                    list.separated = false;
                    list.sort = secondPart;
                }
            } else {
                list.sort = secondPart;
            }

            state.genericLists[index] = list;
        })
    }

    if (config.RPDBkey) {
        console.log(JSON.stringify(config.RPDBkey));
        state.RPDBkey = config.RPDBkey;
    }
}

function getDirection(sort = '', direction = '') {
    sort = sort.split(',').length > 1 ? sort.split(',')[1] : direction;
    
    // Use find() instead of for...in for arrays
    const found = Consts.SortDirections.find(option => option.value == sort);
    return found ? found.name : (direction || 'Ascending');;
}

function getSorting(sort = '') {
    sort = sort.split(',').length ? sort.split(',')[0] : sort;
    const found = Consts.SortOptions.find(option => option.value == sort);
    return found ? found.name : 'Rank';
}

function updateSorting(sort, list) {
    if (list && list.id && typeof list.id == 'string' && list.id.startsWith('trakt_')) {
        const index = state.genericLists.indexOf(list);
        state.genericLists[index].sort = sort.value;
    } else {
        const index = state.lists.indexOf(list);
        state.lists[index].sort = sort.value;
    }
}

function updateSortingDirection(direction, list) {
    if (list && list.id && typeof list.id == 'string' && list.id.startsWith('trakt_')) {
        const index = state.genericLists.indexOf(list);
        state.genericLists[index].direction = direction.value;
    } else {
        const index = state.lists.indexOf(list);
        state.lists[index].direction = direction.value;
    }
}

function startsWithIgnoreCase(str, searchStr) {
    return str.toLowerCase().startsWith(searchStr.toLowerCase());
}

async function fetchLists(endpoint, params = {}) {
    const response = await client.get(endpoint, { params }).catch(e => {
        console.error(e);
        return { data: { items: [], page: 1, total_pages: 1 } };
    });
    return response;
}

async function getListsOflists() {
    try {
        const popularResponse = await fetchLists('/lists/popular');
        state.lists_popular = popularResponse?.data?.items || [];
        state.pagination_popular = {
            page: popularResponse?.data?.page || 1,
            total_pages: popularResponse?.data?.total_pages || 1
        };
        
        const trendingResponse = await fetchLists('/lists/trending');
        state.lists_trending = trendingResponse?.data?.items || [];
        state.pagination_trending = {
            page: trendingResponse?.data?.page || 1,
            total_pages: trendingResponse?.data?.total_pages || 1
        };
        
        if (state.accessToken) {
            const personalResponse = await fetchLists('/lists/personal', { token: state.accessToken });
            state.lists_personal = personalResponse?.data?.items || [];
            state.pagination_personal = {
                page: personalResponse?.data?.page || 1,
                total_pages: personalResponse?.data?.total_pages || 1
            };

            const likedResponse = await fetchLists('/lists/liked', { token: state.accessToken });
            state.lists_liked = likedResponse?.data?.items || [];
            state.pagination_liked = {
                page: likedResponse?.data?.page || 1,
                total_pages: likedResponse?.data?.total_pages || 1
            };
            
        }
    } catch (e) {
        console.error(e);
    }
}

function copyToClipboard() {
    navigator.clipboard.writeText(state.url)
    toast.success('Manifest URL copied to clipboard!');
}

// ========== Modified generateInstallUrl ==========
function generateInstallUrl() {
    let data = {};
    const lists = [];
    let generic = [];
    
    // Use nextTick to ensure DOM is ready
    nextTick(() => {
        loadToken();
        
        state.genericLists.forEach(list => {
            if (!list.value) return;
            if ((list.id == 'trakt_watchlist' || list.id == 'trakt_rec') && !state.accessToken) return;

            let id = list.id;

            if (list.separated)
                id += `:separated`;

            if (list.sort) {
                let sort = list.sort.split(',')[0] || list.sort;
                let direction = list.direction || list.sort.split(',')[1] || 'asc';
                id += `:${sort},${direction}`;
            }

            generic.push(id);
        });

        for (let index in state.lists) {
            let list = state.lists[index];
            if (list.username) {
                if (!list.sort) lists.push(`${list.username}:${list.slug}`)
                else {
                    let sort = list.sort.split(',')[0] || list.sort;
                    let direction = list.direction || list.sort.split(',')[1] || 'asc';
                    lists.push(`${list.username}:${list.slug}:${sort},${direction}`)
                }
            } else {
                lists.push(`${list.id}`)
            }
        }
        
        data['lists'] = generic;
        data['ids'] = lists;
        if (state.accessToken) data['access_token'] = state.accessToken;
        if (state.refreshToken) data['refresh_token'] = state.refreshToken;
        if (state.expires) data['expires'] = state.expires;
        if (state.RPDBkey.valid) data['RPDBkey'] = state.RPDBkey;

        let configurationValue = JSON.stringify(data);
        const configuration = configurationValue && configurationValue.length 
            ? '/' + Buffer.from(configurationValue).toString('base64') 
            : '';
        const location = window.location.host + configuration + '/manifest.json';
        
        const installButton = document.getElementById("install_button");
        if (installButton) {
            installButton.href = 'stremio://' + location;
        }
        state.url = window.location.protocol + '://' + location;
    });
}

function addListUrl() {
    let url, username, slug, sort;
    [url, username, slug, sort] = state.listUrl.match(/https:\/\/trakt\.tv\/users\/([^\/?#]+)\/lists\/([^\/#?]+)(\?[^$]+)?/i);

    if (!url || !username || !slug) {
        toast.error('Invalid Trakt list URL, make sure it starts with https://trakt.tv/');
        return;
    }
    if (sort?.split('?')[1]) {
        sort = sort.split('?')[1].split('=')[1];
    }

    state.lists.push({
        name: slug,
        slug: slug,
        username: username,
        sort: sort || 'rank,asc'
    });

    state.listUrl = '';

    toast.success(slug + " by " + username + " - list added successfully.");

}

const performSearch = async () => {
    if (state.searchQuery !== state.lastSearchQuery) {
        state.lastSearchQuery = state.searchQuery
        state.lists_search = [];
        state.pagination_search = { page: 1, total_pages: 1 };
    }
    
    // Load the page
    await loadPage('search')
}


async function searchLists() {
    if (state.searchQuery !== state.lastSearchQuery) {
        state.lastSearchQuery = state.searchQuery
        state.lists_search = [];
        state.pagination_search = { page: 1, total_pages: 1 };
    }
    showModal('search');
}

function addList(list) {
    state.lists.push({
        name: list.name,
        slug: list.slug,
        username: list.user,
        sort: list.sort || 'rank,asc',
        id: list.id
    });
    toast.success(list.name + " by " + list.user + " - list added successfully.");
}

function removeList(list) {
    const index = state.lists.indexOf(list);
    if (index === -1) {
        return;
    }

    state.lists.splice(index, 1);
}

function readmore(id) {
    document.getElementById(`${id}_more`).classList.remove('hidden');
    document.getElementById(`${id}_less`).classList.add('hidden');
}

function readless(id) {
    document.getElementById(`${id}_less`).classList.remove('hidden');
    document.getElementById(`${id}_more`).classList.add('hidden');
}

async function ValidateRPDB() {
    state.RPDBkey.valid = null;
    try {
        let validate = await client.get(`https://api.ratingposterdb.com/${state.RPDBkey.key}/isValid`)
        if (validate?.data?.valid) state.RPDBkey.valid = validate.data.valid;
        else state.RPDBkey.valid = false;
    } catch (e) {
        state.RPDBkey.valid = false;
    }
    if (state.RPDBkey.valid) state.RPDBkey.tier = parseInt(state.RPDBkey.key[1]);

    if (state.RPDBkey.tier > 1) state.RPDBkey.posters = [{ name: "poster-default" }, { name: "textless-default" }, { name: "poster-certs" }, { name: "poster-mc" }, { name: "poster-rt" }];
    else state.RPDBkey.posters = [{ name: "poster-default" }, { name: "textless-default" }];
}

function RPDBposter(val) {
    state.RPDBkey.poster = val.name;
}

function previousPage(listType) {
    if (!state[`pagination_${listType}`] || state[`pagination_${listType}`].page <= 1) return;
    if (state.lists_loading[listType]) return; // Prevent clicks while loading
    
    state[`pagination_${listType}`].page--;
    loadPage(listType);
}

function nextPage(listType) {
    const pagination = state[`pagination_${listType}`];
    if (!pagination || pagination.page >= pagination.total_pages) return;
    if (state.lists_loading[listType]) return; // Prevent clicks while loading
    
    pagination.page++;
    loadPage(listType);
}

const handlePageChange = async (payload) => {
    const { listType, page } = payload
    
    // Update pagination state
    state[`pagination_${listType}`].page = page
    
    // Load the page
    await loadPage(listType)
}


async function loadPage(listType) {
    // Don't start another load if already loading
    if (state.lists_loading[listType]) return;

    try {
        // Set loading to true
        state.lists_loading[listType] = true;

        const page = state[`pagination_${listType}`]?.page || 1;
        
        switch(listType) {
            case 'popular':
                const popularResponse = await fetchLists('/lists/popular', {page: page});
                state.lists_popular = popularResponse?.data?.items || [];
                state.pagination_popular = {
                    page: popularResponse?.data?.page || 1,
                    total_pages: popularResponse?.data?.total_pages || 1
                };
                break;
                
            case 'trending':
                const trendingResponse = await fetchLists('/lists/trending', {page: page});
                state.lists_trending = trendingResponse?.data?.items || [];
                state.pagination_trending = {
                    page: trendingResponse?.data?.page || 1,
                    total_pages: trendingResponse?.data?.total_pages || 1
                };
                break;
                
            case 'personal':
                if (state.accessToken) {
                    const personalResponse = await fetchLists('/lists/personal', {token: state.accessToken, page: page});
                    state.lists_personal = personalResponse?.data?.items || [];
                    state.pagination_personal = {
                        page: personalResponse?.data?.page || 1,
                        total_pages: personalResponse?.data?.total_pages || 1
                    };
                }
                break;
            case 'liked':
                if (state.accessToken) {
                    const likedResponse = await fetchLists('/lists/liked', {token: state.accessToken, page: page});
                    state.lists_liked = likedResponse?.data?.items || [];
                    state.pagination_liked = {
                        page: likedResponse?.data?.page || 1,
                        total_pages: likedResponse?.data?.total_pages || 1
                    };
                }
                break;
            case 'search':
                const searchResponse = await fetchLists('/lists/' + state.searchQuery, {page: page});
                state.lists_search = searchResponse?.data?.items || [];
                state.pagination_search = {
                    page: searchResponse?.data?.page || 1,
                    total_pages: searchResponse?.data?.total_pages || 1
                };
        }
    } catch (error) {
        console.error('Error loading ' + listType + ' page: ', error);
    } finally {
        // ALWAYS set loading to false when done
        if (state.lists_loading) {
            state.lists_loading[listType] = false;
        }
    }
}
</script>

<style scoped>
/* Add loading/error overlay styles */
.loading-overlay, .error-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: white;
    z-index: 9999;
}

.error-overlay {
    background: #f8d7da;
    color: #721c24;
    text-align: center;
    padding: 2rem;
}

.error-overlay button {
    margin-top: 1rem;
    padding: 0.5rem 1.5rem;
    background: #dc3545;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.spinner {
    width: 40px;
    height: 40px;
    border: 4px solid #f3f3f3;
    border-top: 4px solid #3498db;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 1rem;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

/* Rest of your existing styles remain the same */
.rounded-top {
    border-top-left-radius: 0.75rem;
    border-top-right-radius: 0.75rem;
}

.bg-gradient {
    background-image: linear-gradient(rgb(26 86 219 / var(--tw-bg-opacity)), white);
    padding-bottom: 0;
}

h1 {
    font-size: x-large;
    text-align: center;
    color: red;
    padding-top: 10px;
}

.footer-modal {
    flex-wrap: wrap;
    justify-content: space-between;
    display: flex;
}

.footer-button {
    width: max-content;
    padding-left: 10px;
    padding-right: 10px;
}

.logo {
    margin: auto;
    max-width: 200px;
}

.w-2r {
    width: 2rem;
}

.grabbable {
    display: flex;
    flex-direction: column;
    cursor: move;
    cursor: grab;
    cursor: -moz-grab;
    cursor: -webkit-grab;
}

.grabbable:active {
    cursor: grabbing;
    cursor: -moz-grabbing;
    cursor: -webkit-grabbing;
}

.bg-img {
    background: fixed;
    background-size: cover;
    background-position: center center;
    background-repeat: repeat-y;
}

#RPDB {
    width: -webkit-fill-available;
}

.modal-header {
    position: sticky;
    top: 0;
    background-color: inherit;
    z-index: 1055;
}

.dragable-title {
    margin-top: auto;
    margin-bottom: auto;
    font-size: medium;
    flex: 1;
    padding-left: 5%;
}

.separated-toggle {
    margin-right: 10px;
}

.column {
    flex-direction: column;
}

.sorting-dropdown {
    border-radius: 5px;
}

.flex-even {
    justify-content: space-evenly;
}

.loading-overlay, .error-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: white;
    z-index: 9999;
}

.error-overlay {
    background: #f8d7da;
    color: #721c24;
    text-align: center;
    padding: 2rem;
}

.error-overlay button {
    margin-top: 1rem;
    padding: 0.5rem 1.5rem;
    background: #dc3545;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.spinner {
    width: 40px;
    height: 40px;
    border: 4px solid #f3f3f3;
    border-top: 4px solid #3498db;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 1rem;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

/* Add a style for the OAuth link to ensure it's visible */
.oauth-link {
    display: inline-block;
    text-decoration: none;
}
</style>