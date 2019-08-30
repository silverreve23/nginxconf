<template lang="pug">
    section.section
        //- .notification.is-primary
        //-     button.delete
        //-     | {{ successNotificationText }}
        .container
            .columns
                .column
                    | Sites list:
                    .field.is-grouped.is-grouped-multiline
                        .control.site-list-config(v-for='file in listFilesConfigSite')
                            .tags.has-addons
                                span.tag.is-dark.site-file-name(@click="showFileConfigSite(file)")
                                    | {{ file }}
                                span.tag.is-info.site-file-enable
                                    | {{ isAllowSite(file) }}
                                span.tag.is-delete.site-file-delete(@dblclick="removeFileConfigSite(file)")
                        a.button.is-big.site-file-create(@click="openModalCreateConfigSite") create new site
                    .modal
                        .modal-background
                        .modal-card
                            header.modal-card-head
                                p.modal-card-title Enter name site file
                                button.delete(aria-label="close")
                            section.modal-card-body
                                input.input.is-primary(
                                    type='text'
                                    placeholder='Enter name'
                                    v-model='textInputNameSite'
                                )
                            footer.modal-card-foot
                                button.button.is-success(@click='createNewConfigSite')
                                    | Save changes
                                button.button Cancel
                .column
                    .control.is-small
                        | Site config ({{ openFileSiteConfig }}):
                        textarea.textarea.is-primary(v-model='contentReadedConfigSite' rows='10')
                .column
                    .control.is-small
                        | Host config (system):
                        textarea.textarea.is-primary(v-model='contentReadedConfigHost' rows='10')

</template>

<script>
    const fs = require('fs');
    const dirSitesConfig = '/etc/nginx/sites-available/';
    const dirSitesLinks = '/etc/nginx/sites-enabled/';
    export default {
        name: 'home',
        data(){
            return {
                successNotificationText: null,
                openFileSiteConfig: null,
                textInputNameSite: null,
                contentReadedConfigSite: null,
                contentReadedConfigHost: null,
                listFilesConfigSite: []
            }
        },
        methods: {
            openModalCreateConfigSite(){
                document.querySelector('.modal').classList.add('is-active');
            },
            createNewConfigSite(){
                if(!this.textInputNameSite) throw "Empty name!"
                let areaSiteConfig = document.querySelector('textarea');
                areaSiteConfig.classList.add('.is-loading')
                let fileSiteConfig = dirSitesConfig + this.textInputNameSite;
                this.getContentForSiteConfig(this.textInputNameSite).then(content => {
                    fs.writeFile(fileSiteConfig, content, (err) => {
                        if(err) throw err;
                        this.readFilesConfigSite();
                    })
                })
                areaSiteConfig.classList.remove('.is-loading')
            },
            readFilesConfigSite(){
                fs.readdir(dirSitesConfig, (err, files) => {
                    if (err) throw err;
                    this.openFileSiteConfig = files[0];
                    this.showFileConfigSite(files[0]);
                    this.listFilesConfigSite = files;
                });
            },
            getContentForHostConfig(){
                let fileHostConfig = '/etc/hosts';
                fs.readFile(fileHostConfig, (err, content) => {
                    if (err) throw err;
                    this.contentReadedConfigHost = content;
                });
            },
            getContentForSiteConfig(){
                let fileSiteConfigTpl = __basedir + '/assets/templates/configFileSite.tpl';
                return new Promise((resolve, reject) => {
                    fs.readFile(fileSiteConfigTpl, (err, content) => {
                        if (err) throw err;
                        resolve(content);
                    });
                });
            },
            showFileConfigSite(file){
                let fileSiteConfig = dirSitesConfig + file;
                fs.readFile(fileSiteConfig, (err, content) => {
                    if (err) throw err;
                    this.contentReadedConfigSite = content;
                });
            },
            removeFileConfigSite(file){
                let fileSiteConfig = dirSitesConfig + file;
                fs.unlink(fileSiteConfig, (err) => {
                    if(err) throw err;
                    this.readFilesConfigSite();
                });
            },
            isAllowSite(file){
                let fileSiteLink = dirSitesLinks + file;
                if(fs.existsSync(fileSiteLink)) return 'On';
                return 'Off';
            }
        },
        created(){
            this.readFilesConfigSite();
            this.getContentForHostConfig();
        }
    }
</script>

<style>
    .site-list-config {
        width: 100%;
    }
    .site-file-create {
        width: 100%;
    }
    .site-file-enable {
        width: 20%;
        cursor: pointer;
    }
    .site-file-enable:hover {
        background-color: #397bd6 !important;
    }
    .site-file-delete {
        width: 10% !important;
        cursor: pointer;
    }
    .site-file-name {
        width: 70%;
    }
</style>
