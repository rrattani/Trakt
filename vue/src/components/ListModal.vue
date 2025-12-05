<template>
    <div id="modelId" ref="modalRef" tabindex="-1" aria-hidden="true"
        class="hidden overflow-hidden fixed top-0 right-0 left-0 z-50 w-full md:inset-0 h-modal md:h-full">
        <div class="relative p-4 w-full max-w-2xl h-full md:max-h-screen overflow-hidden">
            <!-- Modal content -->
            <div class="relative bg-white rounded-lg shadow dark:bg-gray-700 overflow-y-auto h-full flex flex-col">
                <!-- Modal header -->
                <div class="modal-header">
                    <div class="flex justify-between items-start p-4 rounded-t border-b dark:border-gray-600">
                        <h3 class="w-full text-xl font-semibold text-gray-900 dark:text-white mr-4">
                            <slot name="header">
                                {{ title }}
                            </slot>
                        </h3>
                        <button @click="close" type="button"
                            class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center dark:hover:bg-gray-600 dark:hover:text-white">
                            <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd"
                                    d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                                    clip-rule="evenodd"></path>
                            </svg>
                            <span class="sr-only">Close modal</span>
                        </button>
                    </div>
                </div>
                <!-- Modal body -->
                <div class="p-6 space-y-6 flex-1 overflow-y-auto relative">
                    <!-- Show spinner when loading -->
                    <div v-if="loading" class="absolute inset-0 bg-white/70 dark:bg-gray-900/70 flex items-center justify-center z-50">
                        <div class="text-center">
                            <svg class="w-12 h-12 mx-auto text-blue-600 animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            <p class="mt-2 text-gray-700 dark:text-gray-300">Loading lists...</p>
                        </div>
                    </div>

                    <!-- Show lists when not loading -->
                    <div v-else-if="items && items.length > 0" class="flex flex-col w-full gap-3 z-10">
                        <div v-for="item in items" :key="item.id"
                            class="w-full p-6 bg-white rounded-lg border border-gray-200 shadow-md dark:bg-gray-800 dark:border-gray-700">
                            <a href="#">
                                <h5
                                    class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white">
                                    {{ item.name }} <small>by {{ item.user }}</small>
                                    <span
                                        class="bg-blue-100 text-blue-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded dark:bg-blue-200 dark:text-blue-800 ml-3">{{
                            item.likes
                        }}
                                        likes</span>
                                    <span
                                        class="bg-blue-100 text-blue-800 text-xs font-semibold mr-2 px-2.5 py-0.5 rounded dark:bg-blue-200 dark:text-blue-800 ml-3">Items
                                        count: {{ item.item_count }}</span>
                                </h5>
                            </a>
                            <p :id="`${modalId}_${item.id}_less`" class="mb-3 font-normal text-gray-700 dark:text-gray-400">
                                {{ item.description.slice(0, 100) }} <button class="readmore"
                                    @click="readmore(item.id)">read more</button></p>
                            <p :id="`${modalId}_${item.id}_more`"
                                class="hidden mb-3 font-normal text-gray-700 dark:text-gray-400">
                                {{ item.description }} <button class="readless" @click="readless(item.id)">read
                                    less</button></p>
                            <button @click="$emit('add-list', item)"
                                class="inline-flex items-center py-2 px-3 text-sm font-medium text-center text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
                                Add list
                                <svg aria-hidden="true" class="ml-2 -mr-1 w-4 h-4" fill="currentColor"
                                    viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd"
                                        d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z"
                                        clip-rule="evenodd"></path>
                                </svg>
                            </button>
                        </div>
                    </div>
                    <div v-else class="text-center text-gray-500 dark:text-gray-400">
                        No lists found
                    </div>
                </div>
                <!-- Footer -->
                <div class="footer-modal border-t border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-700">
                    <div class="flex items-center p-6 space-x-2 rounded-b">
                        <div v-if="showPagination" class="flex items-center justify-center mt-6 space-x-2">
                            <button  @click="previousPage"  type="button"
                                :disabled="!canPrevious" 
                                class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700"> 
                                Previous 
                            </button>
                            <!-- Safe page display -->
                            <span class="text-sm text-gray-700 dark:text-gray-300"> 
                                Page {{ currentPage }} of {{ totalPages }}
                            </span>
                            <button @click="nextPage" type="button" 
                                :disabled="!canNext"
                                class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-100 disabled:opacity-50 disabled:cursor-not-allowed dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700"> 
                                Next 
                            </button>
                        </div>
                    </div>
                    <div class="flex items-center p-6 space-x-2 rounded-b">
                        <button @click="close" type="button" 
                            class="text-gray-500 bg-white hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-blue-300 rounded-lg border border-gray-200 text-sm font-medium px-5 py-2.5 hover:text-gray-900 focus:z-10 dark:bg-gray-700 dark:text-gray-300 dark:border-gray-500 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-600"> 
                            Close 
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed, nextTick, watch } from 'vue'
import { Modal, Dropdown } from 'flowbite'

const props = defineProps({
    modalId: {
        type: String,
        required: true
    },
    listType: {
        type: String,
        required: true,
        validator: (value) => ['popular', 'trending', 'personal', 'search'].includes(value)
    },
    title: {
        type: String,
        default: ''
    },
    items: {
        type: Array,
        default: () => []
    },
    loading: {
        type: Boolean,
        default: false
    },
    pagination: {
        type: Object,
        default: () => ({
            page: 1,
            total_pages: 1
        })
    }
})

const emit = defineEmits(['add-list', 'page-change', 'close', 'opened', 'closed'])

const modalRef = ref(null)
const modalInstance = ref(null)

// Modal Methods
const show = () => {
    if (modalInstance.value) {
        modalInstance.value.show()
    }
}

const hide = () => {
    if (modalInstance.value) {
        modalInstance.value.hide()
    }
}

const close = () => {
    hide()
    emit('close')
}

// Handle ESC key
const handleEscKey = (event) => {
    if (event.key === 'Escape' && modalInstance.value?._isVisible) {
        close()
    }
}

// Pagination Methods
const currentPage = computed(() => {
    return props.pagination?.page || 1
})

const totalPages = computed(() => {
    return props.pagination?.total_pages || 1
})

const showPagination = computed(() => {
    return totalPages.value > 1
})

const canPrevious = computed(() => {
    return !props.loading && currentPage.value > 1
})

const canNext = computed(() => {
    return !props.loading && currentPage.value < totalPages.value
})

const previousPage = () => {
    if (canPrevious.value) {
        emit('page-change', {
            listType: props.listType,
            page: currentPage.value - 1,
            direction: 'previous'
        })
    }
}

const nextPage = () => {
    if (canNext.value) {
        emit('page-change', {
            listType: props.listType,
            page: currentPage.value + 1,
            direction: 'next'
        })
    }
}

// Read more/less Method
const readmore = (itemId) => {
    document.getElementById(`${props.modalId}_${itemId}_less`).classList.add('hidden')
    document.getElementById(`${props.modalId}_${itemId}_more`).classList.remove('hidden')
}

const readless = (itemId) => {
    document.getElementById(`${props.modalId}_${itemId}_more`).classList.add('hidden')
    document.getElementById(`${props.modalId}_${itemId}_less`).classList.remove('hidden')
}

// Initialize modal
const initializeModal = () => {
    if (modalRef.value && !modalInstance.value) {
        modalInstance.value = new Modal(modalRef.value)
        
        // Listen for modal events
        modalRef.value.addEventListener('hidden.bs.modal', () => {
            emit('closed')
        })
        
        modalRef.value.addEventListener('shown.bs.modal', () => {
            emit('opened')
        })
    }
}

onMounted(() => {
    nextTick(() => {
        initializeModal()
    })
    document.addEventListener('keydown', handleEscKey)
})

onUnmounted(() => {
    if (modalInstance.value) {
        modalInstance.value.dispose()
    }
    document.removeEventListener('keydown', handleEscKey)
})

// Expose methods to parent component
defineExpose({
    show,
    hide,
    close
})
</script>