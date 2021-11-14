/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.pipelineresourcesignature;

/// \file
/// Definition of the Diligent::IPipelineResourceSignature interface and related data structures

import bindbc.diligent.primitives.object;
//#include "../../../Platforms/interface/PlatformDefinitions.h"
import bindbc.diligent.graphics.graphicstypes;
import bindbc.diligent.graphics.shader;
import bindbc.diligent.graphics.sampler;
import bindbc.diligent.graphics.shaderresourcevariable;
import bindbc.diligent.graphics.shaderresourcebinding;


/// Immutable sampler description.

/// An immutable sampler is compiled into the pipeline state and can't be changed.
/// It is generally more efficient than a regular sampler and should be used
/// whenever possible.
struct ImmutableSamplerDesc
{
    /// Shader stages that this immutable sampler applies to. More than one shader stage can be specified.
    SHADER_TYPE ShaderStages          = SHADER_TYPE.SHADER_TYPE_UNKNOWN;

    /// The name of the sampler itself or the name of the texture variable that 
    /// this immutable sampler is assigned to if combined texture samplers are used.
    const(char)* SamplerOrTextureName = null;

    /// Sampler description
    SamplerDesc Desc;
}

/// Pipeline resource property flags.
enum PIPELINE_RESOURCE_FLAGS : ubyte
{
    /// Resource has no special properties
    PIPELINE_RESOURCE_FLAG_NONE            = 0x00,

    /// Indicates that dynamic buffers will never be bound to the resource
    /// variable. Applies to SHADER_RESOURCE_TYPE_CONSTANT_BUFFER, 
    /// SHADER_RESOURCE_TYPE_BUFFER_UAV, SHADER_RESOURCE_TYPE_BUFFER_SRV resources.
    ///
    /// \remarks    In Vulkan and Direct3D12 backends, dynamic buffers require extra work
    ///             at run time. If an application knows it will never bind a dynamic buffer to
    ///             the variable, it should use PIPELINE_RESOURCE_FLAG_NO_DYNAMIC_BUFFERS flag
    ///             to improve performance. This flag is not required and non-dynamic buffers
    ///             will still work even if the flag is not used. It is an error to bind a
    ///             dynamic buffer to resource that uses
    ///             PIPELINE_RESOURCE_FLAG_NO_DYNAMIC_BUFFERS flag.
    PIPELINE_RESOURCE_FLAG_NO_DYNAMIC_BUFFERS = 0x01,

    /// Indicates that a texture SRV will be combined with a sampler.
    /// Applies to SHADER_RESOURCE_TYPE_TEXTURE_SRV resources.
    PIPELINE_RESOURCE_FLAG_COMBINED_SAMPLER   = 0x02,

    /// Indicates that this variable will be used to bind formatted buffers.
    /// Applies to SHADER_RESOURCE_TYPE_BUFFER_UAV and SHADER_RESOURCE_TYPE_BUFFER_SRV
    /// resources.
    ///
    /// \remarks    In Vulkan backend formatted buffers require another descriptor type
    ///             as opposed to structured buffers. If an application will be using
    ///             formatted buffers with buffer UAVs and SRVs, it must specify the
    ///             PIPELINE_RESOURCE_FLAG_FORMATTED_BUFFER flag.
    PIPELINE_RESOURCE_FLAG_FORMATTED_BUFFER   = 0x04,

    /// Indicates that resource is a run-time sized shader array (e.g. an array without a specific size).
    PIPELINE_RESOURCE_FLAG_RUNTIME_ARRAY      = 0x08,
    
    PIPELINE_RESOURCE_FLAG_LAST               = PIPELINE_RESOURCE_FLAG_RUNTIME_ARRAY
}

/// Pipeline resource description.
struct PipelineResourceDesc
{
    /// Resource name in the shader
    const(char)*                   Name         = null;

    /// Shader stages that this resource applies to. When multiple shader stages are specified,
    /// all stages will share the same resource.
    ///
    /// \remarks    There may be multiple resources with the same name in different shader stages,
    ///             but the stages specified for different resources with the same name must not overlap.
    SHADER_TYPE                    ShaderStages = SHADER_TYPE.SHADER_TYPE_UNKNOWN;

    /// Resource array size (must be 1 for non-array resources).
    uint                           ArraySize    = 1;

    /// Resource type, see Diligent::SHADER_RESOURCE_TYPE.
    SHADER_RESOURCE_TYPE           ResourceType = SHADER_RESOURCE_TYPE.SHADER_RESOURCE_TYPE_UNKNOWN;

    /// Resource variable type, see Diligent::SHADER_RESOURCE_VARIABLE_TYPE.
    SHADER_RESOURCE_VARIABLE_TYPE  VarType      = SHADER_RESOURCE_VARIABLE_TYPE.SHADER_RESOURCE_VARIABLE_TYPE_MUTABLE;
    
    /// Special resource flags, see Diligent::PIPELINE_RESOURCE_FLAGS.
    PIPELINE_RESOURCE_FLAGS        Flags        = PIPELINE_RESOURCE_FLAGS.PIPELINE_RESOURCE_FLAG_NONE;
};

/// Pipeline resource signature description.
struct PipelineResourceSignatureDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// A pointer to an array of resource descriptions. See Diligent::PipelineResourceDesc.
    const(PipelineResourceDesc)*  Resources  = null;
    
    /// The number of resources in Resources array.
    uint  NumResources  = 0;
    
    /// A pointer to an array of immutable samplers. See Diligent::ImmutableSamplerDesc.
    const(ImmutableSamplerDesc)*  ImmutableSamplers  = null;
    
    /// The number of immutable samplers in ImmutableSamplers array.
    uint  NumImmutableSamplers  = 0;
    
    /// Binding index that this resource signature uses.

    /// Every resource signature must be assign to one signature slot.
    /// The total number of slots is given by MAX_RESOURCE_SIGNATURES constant.
    /// All resource signatures used by a pipeline state must be assigned
    /// to different slots.
    ubyte  BindingIndex = 0;
    
    /// If set to true, textures will be combined with texture samplers.
    /// The CombinedSamplerSuffix member defines the suffix added to the texture variable
    /// name to get corresponding sampler name. When using combined samplers,
    /// the sampler assigned to the shader resource view is automatically set when
    /// the view is bound. Otherwise samplers need to be explicitly set similar to other
    /// shader variables.
    bool UseCombinedTextureSamplers = false;

    /// If UseCombinedTextureSamplers is true, defines the suffix added to the
    /// texture variable name to get corresponding sampler name.  For example,
    /// for default value "_sampler", a texture named "tex" will be combined
    /// with sampler named "tex_sampler".
    /// If UseCombinedTextureSamplers is false, this member is ignored.
    const(char)* CombinedSamplerSuffix = "_sampler";

    /// Shader resource binding allocation granularity

    /// This member defines the allocation granularity for internal resources required by
    /// the shader resource binding object instances.
    uint SRBAllocationGranularity = 1;
}

// {DCE499A5-F812-4C93-B108-D684A0B56118}
static const INTERFACE_ID IID_PipelineResourceSignature = 
    INTERFACE_ID(0xdce499a5, 0xf812, 0x4c93, [0xb1, 0x8, 0xd6, 0x84, 0xa0, 0xb5, 0x61, 0x18]);

/// Pipeline resource signature interface
struct IPipelineResourceSignatureMethods
{
    /// Creates a shader resource binding object

    /// \param [out] ppShaderResourceBinding - Memory location where pointer to the new shader resource
    ///                                        binding object is written.
    /// \param [in] InitStaticResources      - If set to true, the method will initialize static resources in
    ///                                        the created object, which has the exact same effect as calling 
    ///                                        IPipelineResourceSignature::InitializeStaticSRBResources().
    void* CreateShaderResourceBinding(IPipelineResourceSignature*,
                                                     IShaderResourceBinding** ppShaderResourceBinding,
                                                     bool                     InitStaticResources = false);
    

    /// Binds static resources for the specified shader stages in the pipeline resource signature.

    /// \param [in] ShaderStages     - Flags that specify shader stages, for which resources will be bound.
    ///                                Any combination of Diligent::SHADER_TYPE may be used.
    /// \param [in] pResourceMapping - Pointer to the resource mapping interface.
    /// \param [in] Flags            - Additional flags. See Diligent::BIND_SHADER_RESOURCES_FLAGS.
    void* BindStaticResources(IPipelineResourceSignature*,
                                             SHADER_TYPE                 ShaderStages,
                                             IResourceMapping*           pResourceMapping,
                                             BIND_SHADER_RESOURCES_FLAGS Flags);

    /// Returns static shader resource variable. If the variable is not found,
    /// returns nullptr.
    
    /// \param [in] ShaderType - Type of the shader to look up the variable. 
    ///                          Must be one of Diligent::SHADER_TYPE.
    /// \param [in] Name       - Name of the variable.
    ///
    /// \remarks    If a variable is shared between multiple shader stages,
    ///             it can be accessed using any of those shader stages. Even
    ///             though IShaderResourceVariable instances returned by the method
    ///             may be different for different stages, internally they will
    ///             reference the same resource.
    ///
    ///             Only static shader resource variables can be accessed using this method.
    ///             Mutable and dynamic variables are accessed through Shader Resource 
    ///             Binding object.
    ///
    ///             The method does not increment the reference counter of the 
    ///             returned interface, and the application must *not* call Release()
    ///             unless it explicitly called AddRef().
    IShaderResourceVariable** GetStaticVariableByName(IPipelineResourceSignature*,
                                                                     SHADER_TYPE ShaderType,
                                                                     const(char)* Name);
    

    /// Returns static shader resource variable by its index.

    /// \param [in] ShaderType - Type of the shader to look up the variable. 
    ///                          Must be one of Diligent::SHADER_TYPE.
    /// \param [in] Index      - Shader variable index. The index must be between
    ///                          0 and the total number of variables returned by 
    ///                          GetStaticVariableCount().
    ///
    ///
    /// \remarks    If a variable is shared between multiple shader stages,
    ///             it can be accessed using any of those shader stages. Even
    ///             though IShaderResourceVariable instances returned by the method
    ///             may be different for different stages, internally they will
    ///             reference the same resource.
    ///
    ///             Only static shader resource variables can be accessed using this method.
    ///             Mutable and dynamic variables are accessed through Shader Resource 
    ///             Binding object.
    ///
    ///             The method does not increment the reference counter of the 
    ///             returned interface, and the application must *not* call Release()
    ///             unless it explicitly called AddRef().
    IShaderResourceVariable** GetStaticVariableByIndex(IPipelineResourceSignature*,
                                                                      SHADER_TYPE ShaderType,
                                                                      uint      Index);
    

    /// Returns the number of static shader resource variables.

    /// \param [in] ShaderType - Type of the shader.
    ///
    /// \remarks   Only static variables (that can be accessed directly through the PSO) are counted.
    ///            Mutable and dynamic variables are accessed through Shader Resource Binding object.
    uint* GetStaticVariableCount(IPipelineResourceSignature*, SHADER_TYPE ShaderType);
    
    /// Initializes static resources in the shader binding object.

    /// If static shader resources were not initialized when the SRB was created,
    /// this method must be called to initialize them before the SRB can be used.
    /// The method should be called after all static variables have been initialized
    /// in the signature.
    ///
    /// \param [in] pShaderResourceBinding - Shader resource binding object to initialize.
    ///                                      The pipeline resource signature must be compatible
    ///                                      with the shader resource binding object.
    ///
    /// \note   If static resources have already been initialized in the SRB and the method
    ///         is called again, it will have no effect and a warning message will be displayed.
    void* InitializeStaticSRBResources(IPipelineResourceSignature*, IShaderResourceBinding* pShaderResourceBinding);

    /// Returns true if the signature is compatible with another one.

    /// \remarks    Two signatures are compatible if they contain identical resources, defined in the samer order
    ///             disregarding their names.
    bool* IsCompatibleWith(IPipelineResourceSignature*, const(IPipelineResourceSignature)* pPRS);
}

struct IPipelineResourceSignatureVtbl { IPipelineResourceSignatureMethods PipelineResourceSignature; }
struct IPipelineResourceSignature { IPipelineResourceSignatureVtbl* pVtbl; }

PipelineResourceSignatureDesc* IPipelineResourceSignature_GetDesc(IPipelineResourceSignature* object) {
    cast(const(PipelineResourceSignatureDesc)*)IDeviceObject_GetDesc(object);
}

//#    define IPipelineResourceSignature_CreateShaderResourceBinding(This, ...)  CALL_IFACE_METHOD(PipelineResourceSignature, CreateShaderResourceBinding, This, __VA_ARGS__)
//#    define IPipelineResourceSignature_BindStaticResources(This, ...)          CALL_IFACE_METHOD(PipelineResourceSignature, BindStaticResources,         This, __VA_ARGS__)
//#    define IPipelineResourceSignature_GetStaticVariableByName(This, ...)      CALL_IFACE_METHOD(PipelineResourceSignature, GetStaticVariableByName,     This, __VA_ARGS__)
//#    define IPipelineResourceSignature_GetStaticVariableByIndex(This, ...)     CALL_IFACE_METHOD(PipelineResourceSignature, GetStaticVariableByIndex,    This, __VA_ARGS__)
//#    define IPipelineResourceSignature_GetStaticVariableCount(This, ...)       CALL_IFACE_METHOD(PipelineResourceSignature, GetStaticVariableCount,      This, __VA_ARGS__)
//#    define IPipelineResourceSignature_InitializeStaticSRBResources(This, ...) CALL_IFACE_METHOD(PipelineResourceSignature, InitializeStaticSRBResources,This, __VA_ARGS__)
//#    define IPipelineResourceSignature_IsCompatibleWith(This, ...)             CALL_IFACE_METHOD(PipelineResourceSignature, IsCompatibleWith,            This, __VA_ARGS__)

void* IPipelineResourceSignature_CreateShaderResourceBinding(IPipelineResourceSignature* signature, IShaderResourceBinding** ppShaderResourceBinding, bool initStaticResources = false) {
    return signature.pVtbl.PipelineResourceSignature.CreateShaderResourceBinding(signature, ppShaderResourceBinding, initStaticResources);
}

void* IPipelineResourceSignature_BindStaticResources(IPipelineResourceSignature* signature,
                                             SHADER_TYPE                 shaderStages,
                                             IResourceMapping*           pResourceMapping,
                                             BIND_SHADER_RESOURCES_FLAGS flags) {
    return signature.pVtbl.PipelineResourceSignature.BindStaticResources(signature,ShaderStages, pResourceMapping, flags);
}

IShaderResourceVariable** IPipelineResourceSignature_GetStaticVariableByName(IPipelineResourceSignature* signature,
                                                                     SHADER_TYPE shaderType,
                                                                     const(char)* name) {
    return signature.pVtbl.PipelineResourceSignature.GetStaticVariableByName(signature, shaderType, name);
}

IShaderResourceVariable** IPipelineResourceSignature_GetStaticVariableByIndex(IPipelineResourceSignature* signature,
                                                                      SHADER_TYPE shaderType,
                                                                      uint      index) {
    return signature.pVtbl.PipelineResourceSignature.GetStaticVariableByIndex(signature, shaderType, index);
}

uint* IPipelineResourceSignature_GetStaticVariableCount(IPipelineResourceSignature* signature, SHADER_TYPE shaderType) {
    return signature.pVtbl.PipelineResourceSignature.GetStaticVariableCount(signature, shaderType);
}

void* IPipelineResourceSignature_InitializeStaticSRBResources(IPipelineResourceSignature* signature, IShaderResourceBinding* pShaderResourceBinding) {
    return signature.pVtbl.PipelineResourceSignature.InitializeStaticSRBResources(signature, pShaderResourceBinding);
}

bool* IPipelineResourceSignature_IsCompatibleWith(IPipelineResourceSignature* signature, const(IPipelineResourceSignature)* pPRS) {
    return signature.pVtbl.PipelineResourceSignature.IsCompatibleWith(signature, pPRS);
}
